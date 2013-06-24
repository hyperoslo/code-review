require "test_helper"

class Services::ServiceTest < MiniTest::Unit::TestCase
  class Dummy < Services::Service
    class << self
      attr_accessor :foo
    end
  end

  def test_configure
    Dummy.configure do |config|
      config.foo = "foo"
    end

    assert_equal "foo", Dummy.foo
  end

  def test_parsing_valid_response
    response = stub code: 200, body: "body"

    body = Dummy.parse_response response

    assert_equal "body", body
  end

  def test_parsing_invalid_response
    response = stub code: 404, body: "body"

    assert_raises Dummy::Error do
      body = Dummy.parse_response response
    end
  end
end
