require 'thread'

module ThreadSafe
  class Base
    def initialize
      @mutex = Mutex.new
    end

    def thread_safe
      self
    end

    def __in_safe__
      @mutex.synchronize do
        yield
      end
    end

    def __safe_send__(*args, &block)
      __in_safe__ do
        send(*args, &block)
      end
    end

    def self.safe(method_name)
      newname = "#{method_name}_unsafe"
      alias_method newname, method_name

      define_method method_name do |*args, &block|
        __safe_send__(newname, *args, &block)
      end
    end
  end
end
