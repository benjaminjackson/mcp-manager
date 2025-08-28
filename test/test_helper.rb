require 'minitest/autorun'
require 'minitest/mock'
require 'tempfile'
require 'tmpdir'
require 'ostruct'
require_relative '../lib/mcp_manager'

class Minitest::Test
  def setup
    super
    @temp_dir = Dir.mktmpdir
    @original_pwd = Dir.pwd
    Dir.chdir(@temp_dir)
  end

  def teardown
    Dir.chdir(@original_pwd)
    FileUtils.rm_rf(@temp_dir)
    super
  end

  def create_test_config(content)
    File.write('.mcp.yml', content)
  end

  def stub_system_call(command, success: true)
    mock = Minitest::Mock.new
    mock.expect(:call, success, [command])
    Object.stub(:system, mock) do
      yield
    end
    mock.verify
  end

  def test_server_config
    {
      'description' => 'Test MCP server',
      'command' => 'claude mcp add test-server -e API_KEY="$API_KEY" -- npx -y my-test-server',
      'env_vars' => ['API_KEY']
    }
  end

  def setup_test_config
    create_test_config(<<~YAML)
      servers:
        test-server:
          description: "Test MCP server"
          command: claude mcp add test-server -e API_KEY="$API_KEY" -- npx -y my-test-server
          env_vars: ["API_KEY"]
        simple-server:
          description: "Simple server"
          command: claude mcp add simple-server -- npx -y my-simple-server
    YAML
  end
end