require_relative 'lib/Nomnompaleo/version'

Gem::Specification.new do |spec|
  spec.name          = "Nomnompaleo"
  spec.version       = Nomnompaleo::VERSION
  spec.authors       = ["Kevin"]
  spec.email         = ["jasaitiskevin21@gmail.com"]

  spec.summary       = %q{Using the wesbite nomnompaleo.com to get some paleo recipes!}
  spec.description   = %q{Paleo Recipe Scraper}
  spec.homepage      = "https://github.com/kevinjasaitis/Nomnompaleo"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kevinjasaitis/Nomnompaleo"
  spec.metadata["changelog_uri"] = "https://github.com/kevinjasaitis/Nomnompaleo/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

   spec.add_development_dependency "bundler", "~> 2.2.15"
   spec.add_development_dependency "rake", "~> 10.0"
   spec.add_development_dependency "rspec"
   spec.add_development_dependency "pry"

   spec.add_dependency "nokogiri"
end
