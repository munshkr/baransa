require 'ansi/code'

module Baransa
  # Callbacks for em-proxy events
  #
  module Callbacks
    include ANSI::Code
    extend  self

    def on_select
      lambda do |backend|
        puts black_on_white { 'on_select'.ljust(12) } + " #{backend.inspect}"
        backend.increment_counter if Backend.strategy == :balanced
      end
    end

    def on_connect
      lambda do |backend|
        puts black_on_magenta { 'on_connect'.ljust(12) } + ' ' + bold { backend }
      end
    end

    def on_data
      lambda do |data|
        puts black_on_yellow { 'on_data'.ljust(12) }, data
        data
      end
    end

    def on_response
      lambda do |backend, resp|
        puts black_on_green { 'on_response'.ljust(12) } + " from #{backend}", resp
        resp
      end
    end

    def on_finish
      lambda do |backend|
        puts black_on_cyan { 'on_finish'.ljust(12) } + " for #{backend}", ''
        backend.decrement_counter if Backend.strategy == :balanced
      end
    end
  end
end
