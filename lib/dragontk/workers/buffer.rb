require 'thread'
require_relative 'interface'

module DragonTK
  module Workers
    class Buffer
      def initialize
        @q = Queue.new
      end

      def in
        @q
      end

      def out=(q)
        @q = q
      end

      def out
        @q
      end

      def read
        @q.pop
      end

      def write(data)
        @q << data
      end
    end
  end
end
