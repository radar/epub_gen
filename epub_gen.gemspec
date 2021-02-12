require_relative 'lib/epub_gen/version'

Gem::Specification.new do |spec|
  spec.name          = "epub_gen"
  spec.version       = EpubGen::VERSION
  spec.authors       = ["Ryan Bigg"]
  spec.email         = ["me@ryanbigg.com"]

  spec.summary       = %q{Generates an epub file from some HTML}
  spec.homepage      = "https://github.com/radar/epub_gen"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rubyzip', '~> 2.3'
  spec.add_dependency 'nokogiri', '~> 1.11.1'
  spec.add_dependency 'mime-types'
end
