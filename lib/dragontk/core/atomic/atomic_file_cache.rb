require 'json'
require 'yajl'
require 'yaml'
require 'dragontk/core/atomic/atomic'
require 'dragontk/core/atomic/atom'

module DragonTK
  class JsonSerializer
    def decode(contents)
      Yajl::Parser.parse(contents)
    end

    def encode(data)
      Yajl::Encoder.encode(data)
    end

    def load_file(filename)
      decode File.read(filename)
    end

    def self.instance
      @instance ||= new
    end
  end

  class YamlSerializer
    def encode(contents)
      contents.to_yaml
    end

    def decode(contents)
      YAML.parse(contents)
    end

    def load_file(filename)
      YAML.load_file(filename)
    end

    def self.instance
      @instance ||= new
    end
  end

  class AtomicFileCache
    include Atomic

    attr_accessor :filename
    atomic :filename=

    attr_accessor :serializer
    atomic :serializer=

    def initialize(filename, initial = {})
      @filename = filename
      @atom = Atom.new(initial)
      @serializer = YamlSerializer.instance
    end

    def preload
      if File.exist?(@filename)
        load
      else
        save!
      end
    end

    protected def load_data_unsafe(filename)
      @serializer.load_file(filename)
    end

    protected def dump_data_unsafe(data)
      @serializer.encode(data)
    end

    private def save!
      @atom.get do |val|
        File.write(@filename, dump_data_unsafe(val))
      end
    end

    atomic def save
      save!
    end

    atomic def load
      @atom.map do
        load_data_unsafe(filename)
      end
    end

    atomic def map(&block)
      @atom.map(&block)
      save!
    end

    atomic def exist?
      File.exist?(@filename)
    end

    atomic def delete
      File.delete(@filename) if File.exist?(@filename)
    end

    def get(&block)
      @atom.get(&block)
    end
  end
end
