require_relative 'wrapper'

module ThreadSafe
  class GenericWrapper < Wrapper
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
