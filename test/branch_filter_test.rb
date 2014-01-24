require "test_helper"

class BranchFilterTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
    set :odds, "0:0"
  end

  def json
    fixture "gitlab.json"
  end

  def test_inclusion_has_param
    post "/?service=gitlab&only_branches=master", json
    assert_equal last_response.status, 200
  end

  def test_inclusion_has_no_param
    post "/?service=gitlab&only_branches=dev", json
    assert_equal last_response.status, 412
  end

  def test_exclusion_has_param
    post "/?service=gitlab&except_branches=master", json
    assert_equal last_response.status, 412
  end

  def test_exclusion_has_no_param
    post "/?service=gitlab&except_branches=dev", json
    assert_equal last_response.status, 200
  end

  def test_inclusion_empty_params
    post "/?service=gitlab&only_branches=", json
    assert_equal last_response.status, 200
  end

  def test_exclusion_empty_params
    post "/?service=gitlab&except_branches=", json
    assert_equal last_response.status, 200
  end
end
