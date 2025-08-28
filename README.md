# mcp-manager

A command-line tool for managing MCP (Model Context Protocol) servers in Claude projects using a simple YAML configuration file.

## What is this?

MCP servers extend Claude's capabilities by connecting it to external tools and data sources. However, managing multiple MCP servers with their different installation commands, environment variables, and configurations can be complex. 

`mcp-manager` solves this by letting you define all your MCP servers in a single `.mcp.yml` file, then install or remove them with simple commands.

## Installation

Install the gem:

```bash
gem install mcp_manager
```

Copy the example configuration to your project:

```bash
cp .mcp.yml.example .mcp.yml
```

## Configuration

Create a `.mcp.yml` file in your project root. Here's the format:

```yaml
servers:
  server-name:
    description: "What this server does"
    command: "claude mcp add server-name -e REQUIRED_ENV_VAR=\"$REQUIRED_ENV_VAR\" -- installation-command"
    env_vars: ["REQUIRED_ENV_VAR"]
```

### Real Examples

From the included `.mcp.yml.example`:

```yaml
servers:
  github:
    description: "GitHub repository integration (requires Personal Access Token)"
    command: 'claude mcp add github -s local -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_PERSONAL_ACCESS_TOKEN" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server'
    env_vars:
      - GITHUB_PERSONAL_ACCESS_TOKEN

  asana-remote:
    description: "Asana task management (OAuth)"
    command: "claude mcp add asana-remote -- npx -y mcp-remote https://mcp.asana.com/sse"
    env_vars: []

  google-workspace:
    description: "Gmail/Calendar integration (requires OAuth credentials)"
    command: 'claude mcp add google-workspace -s local -e GOOGLE_OAUTH_CLIENT_ID="$GOOGLE_OAUTH_CLIENT_ID" -e GOOGLE_OAUTH_CLIENT_SECRET="$GOOGLE_OAUTH_CLIENT_SECRET" -e OAUTHLIB_INSECURE_TRANSPORT="1" -- uvx workspace-mcp@latest --tools gmail calendar'
    env_vars:
      - GOOGLE_OAUTH_CLIENT_ID
      - GOOGLE_OAUTH_CLIENT_SECRET
```

## Usage

### List available servers
```bash
mcp-manager list
```

### Install a server
```bash
# Set required environment variables first
export GITHUB_PERSONAL_ACCESS_TOKEN="your-token-here"

# Install the server
mcp-manager install github
```

### Remove a server
```bash
mcp-manager uninstall github
```

## Commands

| Command | Aliases | Description |
|---------|---------|-------------|
| `install <server>` | `add` | Install/add an MCP server |
| `uninstall <server>` | `remove`, `rm` | Uninstall/remove an MCP server |
| `list` | | List all available servers with descriptions |
| `--help` | `-h` | Show help message |
| `--version` | `-v` | Show version |

## Environment Variables

Many MCP servers require API keys or OAuth credentials. The tool will check for required environment variables before installation and guide you through setup:

```bash
# Example for GitHub integration
export GITHUB_PERSONAL_ACCESS_TOKEN="your-github-pat"

# Example for Google Workspace
export GOOGLE_OAUTH_CLIENT_ID="your-client-id"
export GOOGLE_OAUTH_CLIENT_SECRET="your-client-secret"
```

Add these to your shell profile (`.zshrc`, `.bashrc`, etc.) to persist them.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ben/mcp-manager.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
