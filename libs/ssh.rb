module Monitoring
  class SSH
    def initialize(host, user, key, cmd, timeout, logger)
      @user     = user
      @host     = host
      @key      = key
      @cmd      = cmd
      @timeout  = timeout
      @logger   = logger
      @cmd_line = construct_cmd
    end

    # Run SSH command on remote host
    def run
      begin
        IO.popen(@cmd_line).read
      rescue
        @logger.error("Failed to execute command on #{@host}")
        ""
      end
    end

    private
    # Build SSH command based on paramters
    def construct_cmd
      cmd = "ssh -i #{@key} " \
            "-o StrictHostKeyChecking=no -o BatchMode=yes " \
            "-o ConnectTimeout=#{@timeout} " \
            "#{@user}@#{@host} \"#{@cmd}\""
      @logger.debug(cmd)
      cmd
    end
  end
end