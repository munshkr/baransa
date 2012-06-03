require 'em-proxy'

module Baransa
  # Wrapping the proxy server
  #
  module Server
    def run(options={})
      host = options[:host] || Settings.address
      port = options[:port] || Settings.port

      puts ANSI::Code.bold { "Launching proxy at #{host}:#{port}...\n" }

      Proxy.start(:host => host, :port => port, :debug => false) do |conn|

        Backend.select do |backend|
          conn.server backend, :host => backend.host, :port => backend.port

          conn.on_connect  &Callbacks.on_connect
          conn.on_data     &Callbacks.on_data
          conn.on_response &Callbacks.on_response
          conn.on_finish   &Callbacks.on_finish
        end

      end
    end

    module_function :run
  end
end

# `em-proxy` prints to stdout when stopping the reactor.
# This replaces the "puts" line with logger.
class Proxy
  def self.stop
    puts ANSI::Code.bold { "\nTerminating proxy" }
    EventMachine.stop
  end
end
