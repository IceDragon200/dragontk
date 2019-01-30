require 'thread'

module DragonTK
  class ThreadPool
    attr_accessor :abort_on_exception
    attr_accessor :log
    attr_reader :thread_limit

    def initialize(options = {}, &block)
      @thread_limit = options.fetch(:thread_limit, self.class.thread_limit)
      @log = options.fetch(:log, nil)
      @abort_on_exception = options.fetch(:abort_on_exception, true)
      @job_id = 0
      @pool_cycle = 0
      @spawn_lock = Mutex.new
      @thread_lock = Mutex.new
      rebuild_available
    end

    protected def rebuild_available
      @thread_lock.synchronize do
        @pool_cycle += 1
        debug_log do |device|
          device.puts "rebuild_available:#{@pool_cycle}"
        end
        @threads = {}
        @available = Queue.new
        @checked_out = {}
        @thread_limit.times do |i|
          @available.push i
        end
      end
    end

    def thread_limit=(limit)
      @thread_limit = limit
      rebuild_available
    end

    protected def debug_log
      yield @log if @log
    end

    private def checkout
      cycle, queue = @thread_lock.synchronize do
        [@pool_cycle, @available]
      end
      index = queue.pop
      @thread_lock.synchronize do
        if cycle == @pool_cycle
          @checked_out[index] = true
          debug_log do |device|
            device.puts "checkout:#{@pool_cycle}:#{index}"
          end
          index
        end
      end
    end

    private def checkin_unsafe(pool_cycle, index)
      return nil unless @pool_cycle == pool_cycle
      @threads.delete(index)
      if @checked_out[index]
        @available.push(index)
        @checked_out.delete(index)
      end
      index
    end
    private def checkin(pool_cycle, index)
      debug_log do |device|
        device.puts "checkin:#{pool_cycle}:#{index}"
      end
      @thread_lock.synchronize do
        checkin_unsafe(pool_cycle, index)
      end
    end

    def spawn(&block)
      job_id, index = @spawn_lock.synchronize do
        @job_id += 1
        [@job_id, checkout()]
      end

      pool_cycle, pool = @thread_lock.synchronize do
        cycle = @pool_cycle
        [@pool_cycle, @threads]
      end

      pool[index] = Thread.new do
        Thread.current.abort_on_exception = @abort_on_exception
        debug_log do |device|
          device.puts "spawn:#{pool_cycle}:#{index}:#{job_id} start"
        end
        time = Time.now
        begin
          block.call index: index, job_id: @job_id
        rescue => ex
          debug_log do |device|
            device.puts "spawn:#{pool_cycle}:#{index}:#{job_id} error"
          end
          raise ex
        end
        debug_log do |device|
          device.puts "spawn:#{pool_cycle}:#{index}:#{job_id} finished"
        end
      ensure
        # always return the index to the thread pool, in case the job fails
        checkin(pool_cycle, index)
      end
    end

    def kill
      @thread_lock.synchronize do
        debug_log do |device|
          device.puts "kill:#{@pool_cycle}"
        end

        @threads.each_pair do |index, thread|
          thread.kill if thread and thread.alive?
          checkin_unsafe(pool_cycle, index)
        end
      end
      rebuild_available
    end

    def await(timeout = 60)
      debug_log do |device|
        device.puts "await"
      end
      while timeout > 0
        cycle, is_empty = @thread_lock.synchronize do
          [@pool_cycle, @checked_out.empty?]
        end
        if is_empty
          break
        else
          sleep 0.1
          timeout -= 0.1
        end
        if timeout <= 0
          raise "timeout (await:#{cycle} #{@checked_out} still checked out)"
        end
      end
    end

    def self.thread_limit
      @thread_limit ||= 5
    end

    class << self
      attr_writer :thread_limit
    end
  end
end
