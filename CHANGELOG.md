# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[0.1.0]: https://github.com/ben/mcp-manager/releases/tag/v0.1.0