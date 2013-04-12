$: << "lib"

ENV["RACK_ENV"]   = "test"
ENV["ODDS"]       = "1:1"
ENV["RECIPIENTS"] = "johannes@hyper.no, espen@hyper.no, tim@hyper.no"

require "application"
require "odds"
require "minitest/unit"
require "minitest/autorun"
require "rack/test"
require "mocha"
