require 'nokogiri'

module EpubGen
  class Container
    def generate
      builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
        xml.container(version: "1.0", xmlns: "urn:oasis:names:tc:opendocument:xmlns:container") do
          xml.rootfiles do
            xml.rootfile("full-path" => "OEBPS/package.opf", "media-type" => "application/oebps-package+xml")
          end
        end
      end
      builder.to_xml
    end
  end
end
