require_relative '../../thread_pool'

module DragonTK
  module Async
    # include this module in any Async::Worker to add subworkers
    module SubWorkers
      # Limits the number of sub workers the worker can have
      #
      # @return [Integer]
      def worker_limit
        @worker_limit ||= 5
      end

      def worker_limit=(value)
        @worker_limit = value
        @q.thread_limit = @worker_limit if @q
      end

      def prepare
        super
        @q = DragonTK::ThreadPool.new
        @q.thread_limit = worker_limit
      end

      def internal_await
        super
        @q.await
      end

      def subwork(&block)
        @q.process(&block)
      end
    end
  end
end
