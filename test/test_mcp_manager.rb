require_relative 'test_helper'

class TestMcpManager < Minitest::Test
  def test_version_defined
    refute_nil McpManager::VERSION
  end
  
  def test_error_class_defined
    assert_kind_of Class, McpManager::Error
    assert McpManager::Error < StandardError
  end
end