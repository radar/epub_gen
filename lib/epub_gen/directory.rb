require 'mime-types'
require 'yaml'

module EpubGen
  Image = Struct.new(:id, :path, :relative_path, :media_type, keyword_init: true)

  class Directory
    attr_reader :path
    def initialize(path)
      @path = path
    end

    def title_page
      path + "title_page.xhtml"
    end

    def html_files
      html_files = Dir["#{path}/html/*.{x,}html"].sort
      html_files.map do |html|
        HTMLFile.new(
          id: "html-" + File.basename(Pathname.new(html).sub_ext('')),
          path: html,
          relative_path: Pathname.new(html).relative_path_from(path + "html")
        )
      end
    end

    def images
      images = Dir["#{path}/images/**/*"].select { |img| File.file?(img) }
      images.map do |image|
        filename = File.basename(Pathname.new(image).sub_ext(''))
        Image.new(
          id: ("image-" + image).tr('/.+', '-'),
          path: image,
          relative_path: Pathname.new(image).relative_path_from(path + "images"),
          media_type: MIME::Types.type_for(image).first.to_s
        )
      end
    end

    def metadata
      YAML.load(File.read(path + "metadata.yml"))
    end
  end
end
