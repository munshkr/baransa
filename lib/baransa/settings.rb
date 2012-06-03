require 'optparse'
require 'yaml'

class Hash
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
    options
    end
  end
end

module Baransa
  module Settings
    extend self

    DEFAULT_CONFIG_FILE = "baransa.yml"

    @_settings = {}
    attr_reader :_settings

    def load_file!(path)
      file_settings = YAML::load_file(path).symbolize_keys
      deep_merge!(@_settings, file_settings)
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
      deep_merge!(@_settings, argv_settings)
    end

    # Deep merging of hashes
    # deep_merge by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
    def deep_merge!(target, data)
      merger = proc { |key, v1, v2|
        Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
        target.merge! data, &merger
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
