require 'dragontk/core/atomic/atomic'

module DragonTK
  class Atom
    include Atomic

    def initialize(value = nil)
      @value = value
    end

    atomic def synchronize
      yield @value
    end

    def get
      synchronize do |val|
        yield val if val
      end
    end

    def map
      synchronize do |val|
        @value = yield val
      end
    end

    def set(val)
      map do
        val
      end
    end
  end
end
