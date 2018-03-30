module Monitoring
  class SSH
    def initialize(host,
                   ssh_opts,
                   cmd,
                   logger)
      @host     = host
      @user     = ssh_opts[:user]
      @key      = ssh_opts[:key]
      @timeout  = ssh_opts[:timeout]
      @cmd      = cmd
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