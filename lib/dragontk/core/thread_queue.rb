require 'dragontk/core/thread_manager'
require 'dragontk/thread_safe/core_ext/array'

class ThreadQueue
  attr_reader :thread_manager

  def initialize
    @mutex = Mutex.new

    @jobs = [].safe_wrap

    @thread_manager = ThreadManager.new
  end

  def add(&block)
    @jobs.push block
  end

  def run
    while @jobs.size > 0
      @thread_manager.spawn &@jobs.shift
      sleep 0.1
    end
  end

  def run_as_server
    @server = Thread.new do
      loop do
        if @jobs.size > 0
          @thread_manager.spawn &@jobs.shift
          sleep 0.1
        end
      end
    end
  end

  def kill
    @server.kill if @server
  end

  def kill!
    kill
    @thread_manager.kill
  end

  def await
    sleep 0.1 until @jobs.empty?
    @thread_manager.await
  end
end
