require_relative 'base'

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
  end
end
