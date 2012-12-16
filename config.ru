require "rubygems"
require "bundler"
require "data_mapper"
require "logger"
$stdout.sync = true
Bundler.require

require "./vzaar_pushover"


run VzaarPushover
