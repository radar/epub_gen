require 'nokogiri'
require 'securerandom'
require 'time'

module EpubGen
  class Package
    attr_reader :book, :uuid

    def initialize(book:, uuid:)
      @book = book
      @uuid = uuid
    end

    def generate
      builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
        xml.package(xmlns:"http://www.idpf.org/2007/opf", version: "3.0", "unique-identifier" => "pub-identifier") do
          metadata(xml)
          manifest(xml)
          spine(xml)
        end
      end
      builder.to_xml
    end

    private

    def metadata(xml)
      xml.metadata("xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
        xml["dc"].language(id: "pub-language") do
          xml.text "en"
        end

        xml["dc"].identifier(id: "pub-identifier") do
          xml.text uuid
        end

        xml.meta(property: "identifier-type", refines: "#pub-identifier") do
          xml.text "uuid"
        end

        # xml.meta(property: "ibooks:specified-fonts") do
        #   xml.text "true"
        # end

        xml["dc"].title(id: "pub-title") do
          xml.text book.title
        end

        xml.meta(property: "title-type", refines: "#pub-title") do
          xml.text "main"
        end

        book.authors.each_with_index do |author, idx|
          xml["dc"].creator(id: "creator#{idx}") do
            xml.text author
          end
        end

        xml.meta(property: "role", refines: "creator1") do
          xml.text "mfr"
        end

        generation_time = Time.now.utc.iso8601

        xml["dc"].date do
          xml.text generation_time
        end

        xml.meta(property: "dcterms:modified") { xml.text generation_time }
      end
    end

    def manifest(xml)
      xml.manifest do
        xml.item(id: "cover", properties: "cover-image", href: "cover.png", "media-type" => "image/png")
        title_page(xml)
        chapters(xml)
        images(xml)
        xml.item(id: "nav", href: "nav.xhtml", "media-type": "application/xhtml+xml", properties: "nav")
        xml.item(id: "ncx", href: "toc.ncx", "media-type": "application/x-dtbncx+xml")
        xml.item(id: "style-style", href: "style.css", "media-type": "text/css")
        xml.item(id: "style-pygments", href: "pygments.css", "media-type": "text/css")
        xml.item(id: "style-fonts", href: "fonts.css", "media-type": "text/css")
        xml.item(id: "font-titilium", href: "titillium.ttf", "media-type": "application/vnd.ms-opentype")
        xml.item(id: "font-titilium-bold", href: "titillium-bold.ttf", "media-type": "application/vnd.ms-opentype")
        xml.item(id: "font-cascadia", href: "CascadiaMono.ttf", "media-type": "application/vnd.ms-opentype")
      end
    end

    def title_page(xml)
      xml.item(id: "title_page", href: "title_page.xhtml", "media-type": "application/xhtml+xml")
    end

    def chapters(xml)
      xml.item(id: "book", href: "book.xhtml", "media-type": "application/xhtml+xml")
    end

    def images(xml)
      book.images.each do |image|
        xml.item(id: image.id, href: image.relative_path, "media-type": image.media_type)
      end
    end

    def spine(xml)
      xml.spine(toc: "ncx") do
        xml.itemref(idref: "title_page")
        xml.itemref(idref: "book")
      end
    end
  end
end
