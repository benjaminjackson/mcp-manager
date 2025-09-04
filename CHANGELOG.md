# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2025-09-04

### Fixed
- Fixed "process status unavailable" errors during install/uninstall operations

## [0.1.2] - 2025-08-28

### Fixed
- Fixed GitHub repository URLs in changelog

## [0.1.1] - 2025-08-28

### Fixed
- Enhanced error handling for install and uninstall commands
- Handle nil values in system call checks

### Changed  
- Improved config initialization and lazy loading
- Updated dependencies and GitHub repository links
- Updated author details with full name and contact email

## [0.1.0] - 2025-08-28

### Added
- Initial release of mcp-manager, a command-line tool for managing MCP servers in Claude projects
- YAML-based configuration system (.mcp.yml)
- Support for installing and uninstalling MCP servers
- Environment variable validation and guidance
- List command to show available servers with descriptions
- Example configuration with popular MCP servers (GitHub, Asana, Google Workspace)
- Comprehensive documentation and usage examples

### Commands
- `mcp-manager install <server>` - Install an MCP server
- `mcp-manager uninstall <server>` - Remove an MCP server  
- `mcp-manager list` - List all configured servers
- Command aliases: `add`, `remove`, `rm`
- Help and version flags

[0.1.3]: https://github.com/benjaminjackson/mcp-manager/releases/tag/v0.1.3
[0.1.2]: https://github.com/benjaminjackson/mcp-manager/releases/tag/v0.1.2
[0.1.1]: https://github.com/benjaminjackson/mcp-manager/releases/tag/v0.1.1
[0.1.0]: https://github.com/benjaminjackson/mcp-manager/releases/tag/v0.1.0