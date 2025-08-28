require_relative 'mcp_manager/version'
require_relative 'mcp_manager/config'
require_relative 'mcp_manager/server'
require_relative 'mcp_manager/cli'

module McpManager
  class Error < StandardError; end
  
  CONFIG_FILE = '.mcp.yml'
end