require_relative 'test_helper'

class TestConfig < Minitest::Test
  def test_loads_valid_config
    config_content = <<~YAML
      servers:
        test-server:
          description: "Test server"
          command: "echo hello"
    YAML
    
    create_test_config(config_content)
    config = McpManager::Config.new
    
    assert_equal ['test-server'], config.list_servers
    assert config.server_exists?('test-server')
    refute config.server_exists?('nonexistent')
  end

  def test_raises_error_for_missing_config
    error = assert_raises(McpManager::Error) do
      McpManager::Config.new
    end
    
    assert_match(/Configuration file .mcp.yml not found/, error.message)
  end

  def test_raises_error_for_invalid_yaml
    create_test_config("invalid: yaml: content:")
    
    error = assert_raises(McpManager::Error) do
      McpManager::Config.new
    end
    
    assert_match(/Invalid YAML/, error.message)
  end

  def test_get_server_config
    config_content = <<~YAML
      servers:
        test-server:
          description: "Test server"
          command: "echo hello"
          env_vars: ["API_KEY"]
    YAML
    
    create_test_config(config_content)
    config = McpManager::Config.new
    
    server_config = config.get_server_config('test-server')
    assert_equal "Test server", server_config['description']
    assert_equal "echo hello", server_config['command']
    assert_equal ["API_KEY"], server_config['env_vars']
    
    assert_nil config.get_server_config('nonexistent')
  end

  def test_check_env_vars
    config_content = <<~YAML
      servers:
        test-server:
          description: "Test server"
    YAML
    
    create_test_config(config_content)
    config = McpManager::Config.new
    
    ENV.stub(:[], proc { |key| key == 'PRESENT_VAR' ? 'value' : nil }) do
      missing = config.check_env_vars(['PRESENT_VAR', 'MISSING_VAR', 'GEMINI_API_KEY'])
      assert_equal ['MISSING_VAR'], missing
    end
  end

  def test_handles_empty_servers
    create_test_config("servers:")
    config = McpManager::Config.new
    
    assert_empty config.list_servers
    refute config.server_exists?('anything')
  end

  def test_custom_config_path
    custom_path = File.join(@temp_dir, 'custom.yml')
    File.write(custom_path, "servers:\n  custom-server:\n    description: Custom")
    
    config = McpManager::Config.new(custom_path)
    assert config.server_exists?('custom-server')
  end
end