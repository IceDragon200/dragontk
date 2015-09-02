require 'dragontk/core_ext/ostruct'
require 'yaml'

module DragonTK
  class Configuration
    attr_reader :filename
    attr_reader :defaults

    def initialize(filename, defaults = {})
      @filename = filename
      @defaults = defaults
    end

    def load_file
      unless File.exist?(@filename)
        File.write(@filename, @defaults.to_yaml)
      end
      YAML.load_file(@filename)
    end

    def get
      @config ||= OpenStruct.new(load_file)
    end

    def [](key)
      get[key]
    end

    def each_pair(&block)
      get.each_pair(&block)
    end

    def each(&block)
      each_pair(&block)
    end
  end
end
