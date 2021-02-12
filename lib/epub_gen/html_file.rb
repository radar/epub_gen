module EpubGen
  HTMLFile = Struct.new(:id, :path, :relative_path, keyword_init: true) do
    def contents
      @contents ||= Nokogiri::HTML.parse(File.read(path))
    end

    def css(*args)
      contents.css(*args)
    end
  end
end
