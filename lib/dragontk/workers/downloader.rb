require 'dragontk/workers/base'

module DragonTK
  module Workers
    class Downloader < Base
      include Async::SubWorkers

      attr_accessor :allow_download

      private def prepare
        super
        @inst = Kona::Instance.new
        @allow_download ||= -> (data) { true }
      end

      private def path_from_options(options)
        l = @logger.new fn: 'path_from_options'
        l.write options
        src = options.fetch :src
        dirname = options[:dirname]
        dest = options[:dest]
        if dest
          l.write msg: 'Given a :dest', dest: dest
        elsif dirname
          dest = File.join(dirname, File.basename(src))
          l.write msg: 'Given a :dirname', dirname: dirname, dest: dest
        else
          l.write msg: 'No valid destination was given', err: 'no_valid_dest'
          return nil, nil
        end
        return src, dest
      end

      def process(options)
        data = options[:data] # pass along data
        l = @logger.new fn: 'download'
        l.write options
        src, dest = *path_from_options(options)

        job_id = SecureRandom.hex(16)
        output_data = { job_id: job_id, src: src, dest: dest, data: data }
        ll = l.new src: src, dest: dest, job_id: job_id
        if @allow_download.call(src: src, dest: dest, data: data)
          dirname = File.dirname(dest)
          FileUtils.mkdir_p dirname
          ll.write msg: 'Spawning download worker', at: 'downloading'
          subwork do |wdata|
            subworker_logger = ll.new subworker_id: wdata[:index]
            subworker_logger.write msg: 'Starting Download', at: 'starting'
            dlr = @inst.dlr_download_link src, dest, noop: @settings.noop
            subworker_logger.write msg: 'Download Complete', at: 'complete', result: dlr.state
            write output_data.merge(dlr: dlr, cause: 'downloaded')
          end
        else
          ll.write msg: 'Download has been skipped', at: 'skipping'
          write output_data.merge(dlr: Kona::DownloadResult.new(:skipped, src, dest), cause: 'skipped')
        end
      end
    end
  end
end
