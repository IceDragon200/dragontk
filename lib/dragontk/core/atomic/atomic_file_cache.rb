require 'dragontk/core/atomic/atomic'
require 'dragontk/core/atomic/atom'

module DragonTK
  class AtomicFileCache
    include Atomic

    attr_accessor :filename
    atomic :filename=

    def initialize(filename, initial = {})
      @filename = filename
      @atom = Atom.new(initial)
    end

    def preload
      if File.exist?(@filename)
        load
      else
        save!
      end
    end

    private def load_data_unsafe(filename)
      YAML.load_file(@filename)
    end

    private def dump_data_unsafe(data)
      data.to_yaml
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
