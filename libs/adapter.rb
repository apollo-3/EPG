require 'socket'

module Monitoring
  class Adapter
    def initialize(output, logger)
      @output = output
      @logger = logger
    end

    def send(metric) end
  end

  class StatsD < Adapter
    def initialize(output, logger)
      super(output, logger)
      @host   = output[:host]
      @port   = output[:port]
      @socket = nil
    end

    # Send metric to StatsD
    def send(metric)
      begin
        open_socket()
        @logger.debug("Send metric \"#{metric.host_prefix_name}\" " \
                      "to #{@host}:#{@port}...")
        @socket.send(metric.format_before_send, 0)
        @socket.close
      rescue
        @logger.error("Failed to send metric \"#{metric.host_prefix_name}\" " \
                      "to StatsD")
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