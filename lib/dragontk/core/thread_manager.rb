require 'thread'

class ThreadManager
  attr_accessor :abort_on_exception
  attr_accessor :log
  attr_reader :thread_limit

  def initialize(options = {}, &block)
    @job_id = 0
    @job_mon = Mutex.new
    @thread_mon = Mutex.new
    @thread_limit = options.fetch(:thread_limit, self.class.thread_limit)
    @threads = []
    @log = options.fetch(:log, nil)
    @abort_on_exception = true

    yield self if block_given?

    rebuild_available
    debug_log { |io| io.puts "NEW #{self.class}.#{__id__}" }
  end

  def rebuild_available
    @available = Queue.new
    @thread_limit.times do |i|
      @available.push i
    end
  end

  def thread_limit=(limit)
    @thread_limit = limit
    debug_log { |io| io.puts "KILLING ALL JOBS #{self.class}.#{__id__}" }
    kill
    @threads.clear
    rebuild_available
  end

  def debug_log
    yield @log if @log
  end

  def lockdown
    yield self
    join
  end

  def delete_thread(thread)
    @thread_mon.synchronize do
      @threads.delete thread
    end
  end

  def add_thread(thread)
    @thread_mon.synchronize do
      @threads << thread
    end
  end

  def spawn(&block)
    @job_id += 1
    @job_mon.synchronize do
      debug_log { |io| io.puts "[job.#{@job_id}] Waiting for available slot" }
      index = @available.pop
      @threads[index] = Thread.new do
        time = Time.now
        id = @job_id
        Thread.current.abort_on_exception = @abort_on_exception

        debug_log { |io| io.puts "[job.#{id}] SPAWN (#{time.strftime("%D %T")})" }

        block.call
        # give back this index
        @threads[index] = nil
        @available.push(index)

        debug_log do |io|
          now = Time.now
          io.puts "[job.#{id}] REMOVED (#{now.strftime("%D %T")}) lived-for: #{now - time} seconds"
        end
      end
    end
  end

  def kill
    @thread_mon.synchronize do
      @threads.compact.each(&:kill)
    end
  end

  def stop
    @thread_mon.synchronize do
      @threads.compact.each(&:stop)
    end
  end

  def start
    @thread_mon.synchronize do
      @threads.compact.each(&:start)
    end
  end

  private def join
    @thread_mon.synchronize do
      @threads.compact.each(&:join)
    end
  end

  def await
    debug_log { |io| io.puts "AWAIT #{self.class}.#{__id__}" }
    join
    sleep 0.1 until @threads.compact.empty?
  end

  alias :add :spawn

  def self.thread_limit
    @thread_limit ||= 5
  end

  class << self
    attr_writer :thread_limit
  end
end
