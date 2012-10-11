require "application"
require "test/unit"
require "rack/test"

ENV["RACK_ENV"]   = "test"
ENV["ODDS"]       = "1:10"
ENV["RECIPIENTS"] = "johannes@hyper.no, espen@hyper.no, tim@hyper.no"

class ApplicationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_says_hello
    post "/", {
      :before => "95790bf891e76fee5e1747ab589903a6a1f80f22",
      :after => "da1560886d4f094c3e6c9ef40349f7d38b5d27d7",
      :ref => "refs/heads/master",
      :user_id => 4,
      :user_name => "John Smith",
      :repository => {
        :name => "Diaspora",
        :url => "localhost/diaspora",
        :description => "",
        :homepage => "localhost/diaspora",
        :private => true
      },
      :commits => [
        {
          :id => "450d0de7532f8b663b9c5cce183b...",
          :message => "Update Catalan translation to e38cb41.",
          :timestamp => "2011-12-12T14:27:31+02:00",
        },
        {
          :id => "ec320de7532f8b663b9c5cce183c...",
          :message => "Update Norwegian translation to e38cb41.",
          :timestamp => "2011-12-12T14:28:35+02:00",
        }
      ]
    }

    raise StandardError, last_response.body
  end
end
