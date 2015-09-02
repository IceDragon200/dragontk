require 'thread'

module DragonTK
  module Atomic
    module ClassMethods
      def atomic(name)
        non_atomic_name = "#{name}_non_atomic"
        alias_method non_atomic_name, name
        define_method name do |*args, &block|
          atomic_mutex.synchronize do
            send(non_atomic_name, *args, &block)
          end
        end
      end
    end

    module InstanceMethods
      private def atomic_mutex
        @atomic_mutex ||= Mutex.new
      end
    end

    def self.included(mod)
      mod.extend ClassMethods
      mod.send :include, InstanceMethods
    end
  end
end
