module Monitoring
  class SSH
    def initialize(host, user, key, cmd)
      @user     = user
      @host     = host
      @key      = key
      @cmd      = cmd
      @cmd_line = construct_cmd
    end

    def run
      begin
        IO.popen(@cmd_line).read
      rescue
        puts "ERROR: failed to execute command on #{@host}"
        ""
      end
    end

    private
    def construct_cmd
      "ssh -i #{@key} " \
      "-o StrictHostKeyChecking=no " \
      "#{@user}@#{@host} \"#{@cmd}\""
    end
  end
end