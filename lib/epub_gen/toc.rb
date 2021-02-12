require 'nokogiri'

class TreeNode
  attr_reader :parent, :id, :text, :children

  def initialize(name, id, text, parent = nil)
    @id = id
    @name = name
    @text = text
    @parent   = parent
    @children = []
  end

  def descendant?(name)
    @name < name
  end

  def add_child(name, id, text)
    TreeNode.new(name, id, text, self).tap do |new_child|
      @children << new_child
    end
  end
end

module EpubGen
  class TOC
    attr_reader :book, :uuid
    def initialize(book:, uuid:)
      @book = book
      @uuid = uuid
    end

    def tree
      root_node = TreeNode.new('h0', nil, 'ROOT')

      header_levels = %w(h1 h2 h3 h4 h5 h6)
      book.html_files.first.css(header_levels.join(', '))
      .reduce(root_node) do |current_tree, tag|
        current_tree = current_tree.parent until current_tree.descendant?(tag.name)
        current_tree.add_child(tag.name, tag["id"], tag.text)
      end

      root_node
    end

    def generate
      builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
        xml.ncx(xmlns:"http://www.daisy.org/z3986/2005/ncx/", version: "2005-1") do
          xml.head do
            xml.meta(name: "dtb:uid", content: uuid)
            xml.meta(name: "dtb:depth", content: 2)
            xml.meta(name: "dtb:totalPageCount", content: "0")
            xml.meta(name: "dtb:maxPageNumber", content: "0")
          end

          xml.docTitle do
            xml.text_ book.title
          end

          play_order = 0

          nav_points = lambda do |nodes|
            nodes.each do |node|
              play_order += 1
              xml.navPoint(id: node.id, playOrder: play_order) do
                xml.navLabel do
                  xml.text_ node.text
                end
                xml.content(src: "book.xhtml##{node.id}")
              end

              nav_points.(node.children)
            end
          end

          xml.navMap do
            play_order += 1
            xml.navPoint(id: "nav_1", playOrder: play_order) do
              xml.navLabel do
                xml.text_ book.title
              end
              xml.content(src: File.basename(book.title_page))
              nav_points.(book.toc.tree.children.first.children)
            end
          end
        end
      end

      builder.to_xml
    end
  end
end
