require 'optparse'

module McpManager
  class CLI
    attr_reader :config
    
    def initialize
      @config = Config.new
    end
    
    def run(args = ARGV)
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: mcp-manager [options] <command> [server_name]"
        
        opts.on("-h", "--help", "Show this help message") do
          puts opts
          show_commands
          exit 0
        end
        
        opts.on("-v", "--version", "Show version") do
          puts VERSION
          exit 0
        end
      end
      
      begin
        parser.parse!(args)
      rescue OptionParser::InvalidOption => e
        error e.message
        puts parser
        exit 1
      end
      
      if args.empty?
        show_usage
        exit 1
      end
      
      command = args[0]
      server_name = args[1]
      
      case command
      when 'install', 'add'
        install_server(server_name)
      when 'uninstall', 'remove', 'rm'
        remove_server(server_name)
      when 'list'
        list_available_servers
      else
        error "Unknown command: #{command}"
        show_usage
        exit 1
      end
    rescue Error => e
      error e.message
      exit 1
    end
    
    private
    
    def install_server(server_name)
      if server_name.nil?
        error "Server name required for install command"
        show_available_servers
        exit 1
      end
      
      server_config = @config.get_server_config(server_name)
      unless server_config
        error "Unknown server: #{server_name}"
        show_available_servers
        exit 1
      end
      
      # Validate required environment variables
      missing_vars = @config.check_env_vars(server_config['env_vars'] || [])
      unless missing_vars.empty?
        error "Missing required environment variables: #{missing_vars.join(', ')}"
        show_env_setup(missing_vars)
        exit 1
      end
      
      server = Server.new(server_name, server_config)
      exit 1 unless server.install
    end
    
    def remove_server(server_name)
      if server_name.nil?
        error "Server name required for uninstall command"
        exit 1
      end
      
      unless @config.server_exists?(server_name)
        error "Unknown server: #{server_name}"
        show_available_servers
        exit 1
      end
      
      server_config = @config.get_server_config(server_name)
      server = Server.new(server_name, server_config)
      exit 1 unless server.uninstall
    end
    
    def list_available_servers
      puts "\nAvailable MCP servers:"
      puts "====================="
      
      @config.servers.each do |name, config|
        puts "\n#{name}:"
        puts "  Description: #{config['description']}"
        
        env_vars = config['env_vars'] || []
        if env_vars.any?
          puts "  Required env vars: #{env_vars.join(', ')}"
        else
          puts "  Required env vars: none"
        end
      end
      
      puts "\nUsage:"
      puts "  mcp-manager install <server_name>"
      puts "  mcp-manager uninstall <server_name>"
    end
    
    def show_available_servers
      puts "\nAvailable servers: #{@config.list_servers.join(', ')}"
      puts "Use 'mcp-manager list' for details"
    end
    
    def show_env_setup(missing_vars)
      puts "\nTo set up missing environment variables, add to your shell profile:"
      missing_vars.each do |var|
        puts "export #{var}=\"your_#{var.downcase}_here\""
      end
      puts "\nThen reload your shell: source ~/.zshrc (or similar)"
    end
    
    def show_usage
      puts "MCP Server Manager"
      puts "=================="
      puts ""
      puts "Usage:"
      puts "  mcp-manager [options] <command> [server_name]"
      puts ""
      puts "Options:"
      puts "  -h, --help     Show this help message"
      puts "  -v, --version  Show version"
      puts ""
      show_commands
    end
    
    def show_commands
      puts "Commands:"
      puts "  install|add <server>          Install/add a server"
      puts "  uninstall|remove|rm <server>  Uninstall/remove a server"
      puts "  list                          List available servers"
      puts ""
      puts "Examples:"
      puts "  mcp-manager install asana-remote"
      puts "  mcp-manager uninstall google-workspace"
      puts "  mcp-manager list"
      puts "  mcp-manager --help"
    end
    
    def info(message)
      puts "ℹ️  #{message}"
    end
    
    def success(message)
      puts "✅ #{message}"
    end
    
    def error(message)
      puts "❌ #{message}"
    end
  end
end