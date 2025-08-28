require_relative 'lib/mcp_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "mcp_manager"
  spec.version       = McpManager::VERSION
  spec.authors       = ["Ben Jackson"]
  spec.email         = ["ben@hearmeout.co"]

  spec.summary       = %q{Utility for managing MCP servers in Claude projects}
  spec.description   = %q{A command-line tool for adding and removing MCP servers to a Claude project with a simple YAML config.}
  spec.homepage      = "https://github.com/benjaminjackson/mcp-manager"
  spec.license       = "MIT"

  spec.metadata["source_code_uri"] = "https://github.com/benjaminjackson/mcp-manager"
  spec.metadata["changelog_uri"] = "https://github.com/benjaminjackson/mcp-manager/blob/main/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-rg", "~> 5.0"
  spec.add_development_dependency "ostruct", "~> 0.5.0"
end