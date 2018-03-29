require 'socket'

module Monitoring
  class Adapter
    def initialize(logger)
      @logger = logger
    end

    def send(metric) end
  end

  class StatsD < Adapter
    def initialize(host, port, logger)
      super(logger)
      @host   = host
      @port   = port
      @socket = nil
    end

    # Send metric to StatsD
    def send(metric)
      begin
        open_socket()
        @logger.debug("Send metrics to #{@host}:#{@port}...")
        @socket.send(metric.format_before_send, 0)
        @socket.close
      rescue
        @logger.error("Failed to send data to StatsD")
      end
    end

    private
    # Open socket connection to StatsD
    def open_socket
      @socket = Socket.new(:INET, :DGRAM)
      @socket.connect_nonblock Socket.sockaddr_in(@port, @host)
    end
  end
end