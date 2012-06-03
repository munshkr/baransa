require 'optparse'
require 'yaml'
require 'ext/hash'

module Baransa
  module Settings
    extend self

    DEFAULT_CONFIG_FILE = "baransa.yml"

    @_settings = {}
    attr_reader :_settings

    def load_file!(path)
      file_settings = YAML::load_file(path).symbolize_keys
      @_settings.deep_merge!(file_settings)
    end

    def parse_argv!(argv=ARGV)
      argv_settings = {}

      # Parse options from command line
      optparse = create_optparse(argv_settings)
      optparse.parse(*argv)

      # Load configuration file if supplied
      if argv_settings[:config]
        load_file!(argv_settings[:config])
      else
        # If there is a config file in the default path, load it
        default_config_path = DEFAULT_CONFIG_FILE
        if File.exists?(default_config_path)
          load_file!(default_config_path)
        end
      end

      # Finally, merge additional supplied settings
      @_settings.deep_merge!(argv_settings)
    end

    def method_missing(name, *args, &block)
      @_settings[name.to_sym] ||
        fail(NoMethodError, "'#{name}' setting was not found", caller)
    end

    def create_optparse(options)
      OptionParser.new do |opts|
        opts.banner = "Usage: baransa <command> <options> -- <application options>"

        opts.on('-h', '--help', "Show this message") do
          puts opts
          exit
        end

        opts.on('-c', '--config FILE', "Load options from configuration file " \
                                       "(default: #{DEFAULT_CONFIG_FILE})") do |file|
          options[:config] = file
        end

        opts.on('-a', '--address HOST', "Bind to HOST address") do |host|
          options[:address] = host
        end

        opts.on('-p', '--port PORT', "Use PORT") do |port|
          options[:port] = port
        end
      end
    end
  end
end
