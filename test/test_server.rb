require_relative 'test_helper'

class TestServer < Minitest::Test
  def setup
    super
    @server_config = test_server_config
    @server = McpManager::Server.new('test-server', @server_config)
  end

  def test_initialization
    assert_equal 'test-server', @server.name
    assert_equal @server_config, @server.config
  end

  def test_description
    assert_equal 'Test MCP server', @server.description
  end

  def test_command
    assert_equal 'claude mcp add test-server -e API_KEY="$API_KEY" -- npx -y my-test-server', @server.command
  end

  def test_env_vars
    assert_equal ['API_KEY'], @server.env_vars
  end

  def test_env_vars_default_empty
    config = {'description' => 'Test', 'command' => 'echo'}
    server = McpManager::Server.new('test', config)
    assert_equal [], server.env_vars
  end

  def test_install_success
    @server.stub(:system, true) do
      original_child_status = defined?($CHILD_STATUS) ? $CHILD_STATUS : nil
      $CHILD_STATUS = OpenStruct.new(success?: true)
      
      output = capture_io do
        result = @server.install
        assert result
      end
      
      assert_match(/Installing MCP server: test-server/, output[0])
      assert_match(/Successfully installed test-server/, output[0])
      
      $CHILD_STATUS = original_child_status
    end
  end

  def test_install_failure
    @server.stub(:system, false) do
      original_child_status = defined?($CHILD_STATUS) ? $CHILD_STATUS : nil
      $CHILD_STATUS = OpenStruct.new(success?: false)
      
      output = capture_io do
        result = @server.install
        refute result
      end
      
      assert_match(/Installing MCP server: test-server/, output[0])
      assert_match(/Failed to install test-server/, output[0])
      
      $CHILD_STATUS = original_child_status
    end
  end

  def test_uninstall_success
    @server.stub(:system, true) do
      original_child_status = defined?($CHILD_STATUS) ? $CHILD_STATUS : nil
      $CHILD_STATUS = OpenStruct.new(success?: true)
      
      output = capture_io do
        result = @server.uninstall
        assert result
      end
      
      assert_match(/Uninstalling MCP server: test-server/, output[0])
      assert_match(/Successfully uninstalled test-server/, output[0])
      
      $CHILD_STATUS = original_child_status
    end
  end

  def test_uninstall_failure
    @server.stub(:system, true) do
      original_child_status = defined?($CHILD_STATUS) ? $CHILD_STATUS : nil
      $CHILD_STATUS = OpenStruct.new(success?: false)
      
      output = capture_io do
        result = @server.uninstall
        refute result
      end
      
      assert_match(/Uninstalling MCP server: test-server/, output[0])
      assert_match(/Failed to uninstall test-server/, output[0])
      
      $CHILD_STATUS = original_child_status
    end
  end

  def test_install_with_nil_child_status
    assert_method_handles_nil_child_status(:install, nil, /Installing MCP server: test-server/, /Failed to install test-server/)
  end

  def test_install_system_returns_false_with_nil_child_status
    assert_method_handles_nil_child_status(:install, false, /Installing MCP server: test-server/, /Failed to install test-server/)
  end

  def test_uninstall_with_nil_child_status
    assert_method_handles_nil_child_status(:uninstall, nil, /Uninstalling MCP server: test-server/, /Failed to uninstall test-server/)
  end

  def test_uninstall_system_returns_false_with_nil_child_status
    assert_method_handles_nil_child_status(:uninstall, false, /Uninstalling MCP server: test-server/, /Failed to uninstall test-server/)
  end

  private

  def assert_method_handles_nil_child_status(method, system_return_value, start_message, failure_message)
    @server.stub(:system, system_return_value) do
      original_child_status = defined?($CHILD_STATUS) ? $CHILD_STATUS : nil
      $CHILD_STATUS = nil
      
      output = capture_io do
        result = @server.send(method)
        refute result
      end
      
      assert_match(start_message, output[0])
      assert_match(failure_message, output[0])
      
      $CHILD_STATUS = original_child_status
    end
  end

  def test_to_s
    expected = "test-server: Test MCP server"
    assert_equal expected, @server.to_s
  end
end