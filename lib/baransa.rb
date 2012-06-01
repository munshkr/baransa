require "baransa/version"
require "baransa/backend"
require "baransa/callbacks"
require "baransa/server"

module Baransa
  BACKENDS = [
    { :url => "http://127.0.0.1:8123" },
  ]
end
