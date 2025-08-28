require 'stringio'

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
      
      stderr_output = capture_stderr do
        system(command, out: File::NULL)
      end
      
      if $CHILD_STATUS&.success?
        puts "✅ Successfully installed #{@name}"
        true
      else
        error_message = build_error_message("install", stderr_output)
        puts "❌ Failed to install #{@name}: #{error_message}"
        false
      end
    end
    
    def uninstall
      puts "ℹ️  Uninstalling MCP server: #{@name}"
      
      uninstall_command = "claude mcp remove #{@name}"
      puts "ℹ️  Executing: #{uninstall_command}"
      
      stderr_output = capture_stderr do
        system(uninstall_command, out: File::NULL)
      end
      
      if $CHILD_STATUS&.success?
        puts "✅ Successfully uninstalled #{@name}"
        true
      else
        error_message = build_error_message("uninstall", stderr_output)
        puts "❌ Failed to uninstall #{@name}: #{error_message}"
        false
      end
    end
    
    def to_s
      "#{@name}: #{description}"
    end

    private

    def capture_stderr
      original_stderr = $stderr
      $stderr = StringIO.new
      yield
      $stderr.string
    ensure
      $stderr = original_stderr
    end

    def build_error_message(operation, stderr_output)
      if $CHILD_STATUS.nil?
        "process status unavailable"
      elsif $CHILD_STATUS.respond_to?(:exitstatus) && $CHILD_STATUS.exitstatus
        message = "command failed with exit code #{$CHILD_STATUS.exitstatus}"
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