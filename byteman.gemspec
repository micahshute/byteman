require_relative 'lib/byteman/version'

Gem::Specification.new do |spec|
  spec.name          = "byteman"
  spec.version       = Byteman::VERSION
  spec.authors       = ["micahshute"]
  spec.email         = ["micah.shute@gmail.com"]

  spec.summary       = %q{Easily manipulate and transform data into different forms (e.g. byte strings, byte array buffers, hexdigests)}
  spec.description   = %q{Allows simple transformation of data into hex strings, hexdigest strings, integer byte arrays, etc. as well as padding your data to a certain byte length}
  spec.homepage      = "https://github.com/micahshute/byteman"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/micahshute/byteman"
  spec.metadata["changelog_uri"] = "https://github.com/micahshute/byteman"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
