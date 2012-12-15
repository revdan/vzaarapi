require "rubygems"
require "bundler"
require "mongoid"

Bundler.require

require "./vzaar_pushover"


run VzaarPushover
