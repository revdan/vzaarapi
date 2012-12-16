require "rubygems"
require "bundler"
require "data_mapper"
require "logger"

Bundler.require

require "./vzaar_pushover"


run VzaarPushover
