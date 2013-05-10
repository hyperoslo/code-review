require "test_helper"

class ServicesTest < MiniTest::Unit::TestCase
  def test_lookup_existing_service
    service = Services.lookup "github"

    assert_equal Services::GitHub, service
  end

  def test_lookup_unknown_service
    assert_raises Services::UnknownService do
      service = Services.lookup "gitfoo"
    end
  end
end
