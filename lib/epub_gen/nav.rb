module EpubGen
  class Nav
    attr_reader :book

    def initialize(book:)
      @book = book
    end

    def generate
      builder = Nokogiri::HTML::Builder.new do |doc|
        doc.doc.internal_subset.remove
        doc.doc.create_internal_subset('html', nil, nil)
        doc.html(xmlns: "http://www.w3.org/1999/xhtml", "xmlns:epub" => "http://www.idpf.org/2007/ops", "xml:lang" => "en", "lang" => "en") do
          doc.head do
            doc.meta("charset" => "UTF-8")
            doc.title book.title
            # TODO: Bring these in dynamically!
            doc.link("rel" => "stylesheet", type: "text/css", href: "style.css")
          end

          doc.body do
            doc.h1 book.title
            doc.nav("epub:type" => "toc", "id" => "toc") do
              doc.h2 "Table of Contents"

              doc.ol do
                doc.li do
                  doc.a("href" => "title_page.xhtml") do
                    doc.text book.title
                  end
                  # if book.toc.tree.children.first.children.any?
                  #   doc.ol do
                  #     sub_nav(doc, book.toc.tree.children.first.children)
                  #   end
                  # end
                end
              end
            end
          end
        end
      end

      builder.to_html
    end

    def sub_nav(doc, children)
      children.each do |child|
        doc.li do
          doc.a("href" => "book.xhtml##{child.id}") do
            doc.text child.text
          end

          sub_nav(doc, child.children)
        end
      end
    end
  end
end
