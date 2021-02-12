require 'forwardable'

module EpubGen
  class Book
    attr_reader :path, :uuid

    def initialize(path:, uuid:)
      @path = Pathname.new(path)
      @uuid = uuid
    end

    def directory
      EpubGen::Directory.new(path)
    end

    def title
      metadata["title"]
    end

    def authors
      metadata["authors"]
    end

    def html_files
      directory.html_files
    end

    def images
      directory.images
    end

    def title_page
      directory.title_page
    end

    def package
      EpubGen::Package.new(book: self, uuid: uuid)
    end

    def toc
      EpubGen::TOC.new(book: self, uuid: uuid)
    end

    def nav
      EpubGen::Nav.new(book: self)
    end

    private

    def metadata
      directory.metadata
    end
  end
end
