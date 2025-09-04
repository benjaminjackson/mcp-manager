require 'open3'

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
      
      stdout, stderr_output, exit_status = Open3.capture3(command)
      
      if exit_status&.success?
        puts "✅ Successfully installed #{@name}"
        true
      else
        error_message = build_error_message("install", stderr_output, exit_status)
        puts "❌ Failed to install #{@name}: #{error_message}"
        false
      end
    end
    
    def uninstall
      puts "ℹ️  Uninstalling MCP server: #{@name}"
      
      uninstall_command = "claude mcp remove #{@name}"
      puts "ℹ️  Executing: #{uninstall_command}"
      
      stdout, stderr_output, exit_status = Open3.capture3(uninstall_command)
      
      if exit_status&.success?
        puts "✅ Successfully uninstalled #{@name}"
        true
      else
        error_message = build_error_message("uninstall", stderr_output, exit_status)
        puts "❌ Failed to uninstall #{@name}: #{error_message}"
        false
      end
    end
    
    def to_s
      "#{@name}: #{description}"
    end

    private


    def build_error_message(operation, stderr_output, exit_status = nil)
      if exit_status.nil?
        "process status unavailable"
      elsif exit_status.respond_to?(:exitstatus) && exit_status.exitstatus
        message = "command failed with exit code #{exit_status.exitstatus}"
        if stderr_output && !stderr_output.strip.empty?
          message += " (#{stderr_output.strip})"
        end
        message
      else
        message = "command failed"
        if stderr_output && !stderr_output.strip.empty?
          message += " (#{stderr_output.strip})"
        end
        message
      end
    end
  end
end