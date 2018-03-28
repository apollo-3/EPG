module Monitoring
  class StatsD
    def initialize(host, port)
      @host   = host
      @port   = port
      @socket = nil
    end

    def send(metric, value, type)
      begin
        open_socket()
        @socket.send("#{metric}:#{value}|#{type}", 0)
        @socket.close
      rescue
        puts "ERROR: failed to send data via socket"
      end
    end

    private
    def open_socket
      @socket = Socket.new(:INET, :DGRAM)
      @socket.connect_nonblock Socket.sockaddr_in(@port, @host)
    end
  end
end