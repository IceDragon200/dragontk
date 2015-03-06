require 'dragontk/thread_safe/base'

module ThreadSafe
  class Wrapper < Base
    attr_reader :value

    def initialize(value)
      @value = value
      super()
    end

    def self.wrap(method_name)
      safe(define_method(method_name) do |*args, &block|
        @value.send(method_name, *args, &block)
      end)
    end

    def safe_wrap
      self
    end

    def method_missing(sym, *args, &block)
      if @value.respond_to?(sym)
        __in_safe__ do
          @value.send(sym, *args, &block)
        end
      else
        super
      end
    end
  end
end
