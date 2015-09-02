require 'dragontk/core/async'
require 'dragontk/workers/stop'
require 'dragontk/workers/interface'
require 'thread'
require 'ostruct'

module DragonTK
  module Workers
    class Base < Async::Worker
      include Workers::Interface

      def initialize_members(options)
        super
        @in = Queue.new
      end

      def process(data)
        fail
      end

      def main
        loop do
          data = read
          break if data == Stop
          process data
        end
      end

      def stop
        self.in << Stop
      end

      def stop!
        stop
        await
      end
    end
  end
end
