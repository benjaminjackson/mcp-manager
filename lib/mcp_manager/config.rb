require 'yaml'

module McpManager
  class Config
    attr_reader :config_path, :servers
    
    def initialize(config_path = nil)
      @config_path = config_path || File.join(Dir.pwd, CONFIG_FILE)
      load_config
    end
    
    def load_config
      unless File.exist?(@config_path)
        raise Error, "Configuration file #{CONFIG_FILE} not found in current directory"
      end
      
      @config = YAML.safe_load_file(@config_path)
      @servers = @config['servers'] || {}
    rescue Psych::SyntaxError => e
      raise Error, "Invalid YAML in #{CONFIG_FILE}: #{e.message}"
    end
    
    def server_exists?(name)
      @servers.key?(name)
    end
    
    def get_server_config(name)
      @servers[name]
    end
    
    def list_servers
      @servers.keys
    end
    
    def check_env_vars(required_vars)
      missing = []
      required_vars.each do |var|
        # GEMINI_API_KEY is optional if using OAuth
        next if var == 'GEMINI_API_KEY'
        
        if ENV[var].nil? || ENV[var].empty?
          missing << var
        end
      end
      missing
    end
  end
end