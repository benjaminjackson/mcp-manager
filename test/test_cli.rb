require_relative 'test_helper'

class TestCLI < Minitest::Test
  def setup
    super
    setup_test_config
  end

  def test_version_flag
    output = capture_io do
      assert_raises(SystemExit) { McpManager::CLI.new.run(['--version']) }
    end
    
    assert_match(/0\.1\.0/, output[0])
  end

  def test_help_flag
    output = capture_io do
      assert_raises(SystemExit) { McpManager::CLI.new.run(['--help']) }
    end
    
    assert_match(/Usage: mcp-manager/, output[0])
    assert_match(/Commands:/, output[0])
  end

  def test_no_arguments_shows_usage
    output = capture_io do
      assert_raises(SystemExit) { McpManager::CLI.new.run([]) }
    end
    
    assert_match(/MCP Server Manager/, output[0])
    assert_match(/Usage:/, output[0])
  end

  def test_unknown_command
    output = capture_io do
      assert_raises(SystemExit) { McpManager::CLI.new.run(['unknown']) }
    end
    
    assert_match(/Unknown command: unknown/, output[0])
  end

  def test_list_command
    output = capture_io do
      McpManager::CLI.new.run(['list'])
    end
    
    assert_match(/Available MCP servers/, output[0])
    assert_match(/test-server/, output[0])
    assert_match(/simple-server/, output[0])
    assert_match(/Test MCP server/, output[0])
    assert_match(/Required env vars: API_KEY/, output[0])
    assert_match(/Required env vars: none/, output[0])
  end

  def test_install_without_server_name
    output = capture_io do
      assert_raises(SystemExit) { McpManager::CLI.new.run(['install']) }
    end
    
    assert_match(/Server name required/, output[0])
    assert_match(/Available servers: test-server, simple-server/, output[0])
  end

  def test_install_unknown_server
    output = capture_io do
      assert_raises(SystemExit) { McpManager::CLI.new.run(['install', 'unknown']) }
    end
    
    assert_match(/Unknown server: unknown/, output[0])
  end

  def test_install_missing_env_vars
    ENV.stub(:[], nil) do
      output = capture_io do
        assert_raises(SystemExit) { McpManager::CLI.new.run(['install', 'test-server']) }
      end
      
      assert_match(/Missing required environment variables: API_KEY/, output[0])
      assert_match(/export API_KEY/, output[0])
    end
  end

  def test_successful_install
    ENV.stub(:[], proc { |key| key == 'API_KEY' ? 'test-key' : nil }) do
      output = capture_io do
        Object.stub(:system, true) do
          $CHILD_STATUS = OpenStruct.new(success?: true)
          McpManager::CLI.new.run(['install', 'test-server'])
        end
      end
      
      assert_match(/Installing MCP server: test-server/, output[0])
    end
  end

  def test_install_aliases
    ENV.stub(:[], proc { |key| key == 'API_KEY' ? 'test-key' : nil }) do
      ['install', 'add'].each do |command|
        output = capture_io do
          Object.stub(:system, true) do
            $CHILD_STATUS = OpenStruct.new(success?: true)
            McpManager::CLI.new.run([command, 'test-server'])
          end
        end
        
        assert_match(/Installing MCP server: test-server/, output[0])
      end
    end
  end

  def test_uninstall_without_server_name
    output = capture_io do
      assert_raises(SystemExit) { McpManager::CLI.new.run(['uninstall']) }
    end
    
    assert_match(/Server name required for uninstall/, output[0])
  end

  def test_uninstall_unknown_server
    output = capture_io do
      assert_raises(SystemExit) { McpManager::CLI.new.run(['uninstall', 'unknown']) }
    end
    
    assert_match(/Unknown server: unknown/, output[0])
  end

  def test_successful_uninstall
    output = capture_io do
      Object.stub(:system, true) do
        $CHILD_STATUS = OpenStruct.new(success?: true)
        McpManager::CLI.new.run(['uninstall', 'test-server'])
      end
    end
    
    assert_match(/Uninstalling MCP server: test-server/, output[0])
  end

  def test_uninstall_aliases
    ['uninstall', 'remove', 'rm'].each do |command|
      output = capture_io do
        Object.stub(:system, true) do
          $CHILD_STATUS = OpenStruct.new(success?: true)
          McpManager::CLI.new.run([command, 'test-server'])
        end
      end
      
      assert_match(/Uninstalling MCP server: test-server/, output[0])
    end
  end
end