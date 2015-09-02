module DragonTK
  module Workers
    module Interface
      module Writer
        attr_accessor :out

        private def write(data)
          @out << data if @out
        end
      end

      module Reader
        attr_accessor :in

        private def read
          return nil unless @in
          @in.pop
        end
      end

      include Writer
      include Reader
    end
  end
end
