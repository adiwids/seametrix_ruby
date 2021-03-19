require_relative 'lib/seametrix_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "seametrix_ruby"
  spec.version       = SeametrixRuby::VERSION
  spec.authors       = ["adiwids"]
  spec.email         = ["adi.widyawan@bocistudio.com"]

  spec.summary       = %q{Ruby wrapper for Seametrix API}
  spec.description   = %q{Ruby wrapper for Seametrix API}
  spec.homepage      = "https://www.bocistudio.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = ""
  #spec.metadata["changelog_uri"] = ""

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  # Dependencies
  spec.required_ruby_version = '>= 2.5.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'simplecov', '>= 0.19.1'

  spec.add_dependency 'faraday', '~> 1.3.0'
  spec.add_dependency 'faraday_middleware', '~> 1.0.0'
  spec.add_dependency 'multi_json', '>= 1.11.2'
  spec.add_dependency 'hashie', '~> 4.1.0'
  spec.add_dependency 'activesupport', '>= 5.2'
end
