module DragonTK
  module Workers
    module Interface
      module Writer
        attr_accessor :out

        def write(data)
          @out << data if @out
        end
      end

      module Reader
        attr_accessor :in

        def read
          return nil unless @in
          @in.pop
        end
      end

      include Writer
      include Reader
    end
  end
end
