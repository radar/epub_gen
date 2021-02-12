module EpubGen
  class TOC
    attr_reader :directory, :uuid
    def initialize(directory:, uuid:)
      @directory = directory
      @uuid = uuid
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
            xml.text_ "Active Rails"
          end

          xml.navMap do
            xml.navPoint(id: "nav_1", playOrder: "1") do
              xml.navLabel do
                xml.text_ "Active Rails"
              end
              xml.content(src: File.basename(directory.title_page))
            end

            xml.navPoint(id: "nav_2", playOrder: "2") do
              xml.navLabel do
                xml.text_ "1. Ruby on Rails, the framework"
              end
              xml.content(src: "ch01.xhtml")
            end

            xml.navPoint(id: "nav_3", playOrder: "3") do
              xml.navLabel do
                xml.text_ "2. Writing automated tests"
              end
              xml.content(src: "ch02.xhtml")
            end

            xml.navPoint(id: "nav_4", playOrder: "4") do
              xml.navLabel do
                xml.text_ "3. Developing a real Rails application"
              end
              xml.content(src: "ch03.xhtml")
            end

            xml.navPoint(id: "nav_5", playOrder: "5") do
              xml.navLabel do
                xml.text_ "4. Oh, CRUD!"
              end
              xml.content(src: "ch04.xhtml")
            end

            xml.navPoint(id: "nav_6", playOrder: "6") do
              xml.navLabel do
                xml.text_ "5. Nested resources"
              end
              xml.content(src: "ch05.xhtml")
            end
          end
        end
      end

      builder.to_xml
    end
  end
end
