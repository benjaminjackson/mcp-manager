require_relative 'test_helper'

class TestMcpManager < Minitest::Test
  def test_version_defined
    refute_nil McpManager::VERSION
    assert_match(/\A\d+\.\d+\.\d+\z/, McpManager::VERSION)
  end
  
  def test_error_class_defined
    assert_kind_of Class, McpManager::Error
    assert McpManager::Error < StandardError
  end

  def test_config_file_constant
    assert_equal '.mcp.yml', McpManager::CONFIG_FILE
  end

  def test_module_structure
    assert_respond_to McpManager, :const_defined?
    assert McpManager.const_defined?(:Config)
    assert McpManager.const_defined?(:Server)
    assert McpManager.const_defined?(:CLI)
    assert McpManager.const_defined?(:VERSION)
  end

  def test_integration_workflow
    config_content = <<~YAML
      servers:
        integration-test:
          description: "Integration test server"
          command: "echo test"
    YAML
    
    create_test_config(config_content)
    
    # Test full workflow: config -> server -> cli
    config = McpManager::Config.new
    assert config.server_exists?('integration-test')
    
    server_config = config.get_server_config('integration-test')
    server = McpManager::Server.new('integration-test', server_config)
    assert_equal 'Integration test server', server.description
    
    # Test CLI can load config
    cli = McpManager::CLI.new
    assert_kind_of McpManager::Config, cli.config
  end

  def test_error_inheritance
    error = McpManager::Error.new("test message")
    assert_kind_of StandardError, error
    assert_equal "test message", error.message
  end
end