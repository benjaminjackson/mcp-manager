module McpManager
  class Server
    attr_reader :name, :config
    
    def initialize(name, config)
      @name = name
      @config = config
    end
    
    def description
      @config['description']
    end
    
    def command
      @config['command']
    end
    
    def env_vars
      @config['env_vars'] || []
    end
    
    def install
      puts "ℹ️  Installing MCP server: #{@name}"
      puts "ℹ️  Description: #{description}"
      puts "ℹ️  Executing: #{command}"
      
      system(command, out: File::NULL, err: File::NULL)
      if $CHILD_STATUS.success?
        puts "✅ Successfully installed #{@name}"
        true
      else
        puts "❌ Failed to install #{@name}"
        false
      end
    end
    
    def uninstall
      puts "ℹ️  Uninstalling MCP server: #{@name}"
      
      uninstall_command = "claude mcp remove #{@name}"
      puts "ℹ️  Executing: #{uninstall_command}"
      
      system(uninstall_command, out: File::NULL, err: File::NULL)
      if $CHILD_STATUS.success?
        puts "✅ Successfully uninstalled #{@name}"
        true
      else
        puts "❌ Failed to uninstall #{@name}"
        false
      end
    end
    
    def to_s
      "#{@name}: #{description}"
    end
  end
end