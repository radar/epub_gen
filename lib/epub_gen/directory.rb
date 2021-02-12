require 'mime-types'

module EpubGen
  Chapter = Struct.new(:id, :path, :relative_path, keyword_init: true)
  Image = Struct.new(:id, :path, :relative_path, :media_type, keyword_init: true)

  class Directory
    attr_reader :path
    def initialize(path)
      @path = path
    end

    def title_page
      path + "title_page.xhtml"
    end

    def chapters
      chapter_files = Dir["#{path}/chapters/*.{x,}html"].sort
      p chapter_files
      chapter_files.map do |chapter|
        Chapter.new(
          id: "chapter-" + File.basename(Pathname.new(chapter).sub_ext('')),
          path: chapter,
          relative_path: Pathname.new(chapter).relative_path_from(path + "chapters")
        )
      end
    end

    def images
      images = Dir["#{path}/images/**/*"].select { |img| File.file?(img) }
      images.map do |image|
        filename = File.basename(Pathname.new(image).sub_ext(''))
        Image.new(
          id: "image-" + filename,
          path: image,
          relative_path: Pathname.new(image).relative_path_from(path + "images"),
          media_type: MIME::Types.type_for(image).first.to_s
        )
      end
    end
  end
end
