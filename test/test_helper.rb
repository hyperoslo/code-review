$: << "lib"

require "simplecov"
require "coveralls"

SimpleCov.command_name "Unit Tests"

Coveralls.wear!

ENV["RACK_ENV"]   = "test"
ENV["ODDS"]       = "1:1"
ENV["REVIEWERS"]  = "johannes@gmail.com:johannes@hyper.no,tim@gmail.com:tim@hyper.no,espen@gmail.com:espen@hyper.no"

require "application"
require "odds"
require "minitest/unit"
require "minitest/autorun"
require "rack/test"
require "mocha"
