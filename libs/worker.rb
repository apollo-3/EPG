require_relative 'ssh'

module Monitoring
  class Worker
    attr_accessor :host
    attr_reader   :result
    def initialize(host, user, key, timeout, logger)
      @host    = host
      @user    = user
      @key     = key
      @timeout = timeout
      @cmd     = ""
      @result  = nil
      @logger  = logger
    end

    # Execute worker
    def run
      @result = SSH.new(@host, @user, @key, @cmd, @timeout, @logger).run
    end

    # Transform result to metrics array
    def result_to_metrics() end
  end

  class PSWorker < Worker
    def initialize(host, user, key, timeout, logger)
      super(host, user, key, timeout, logger)
      @cmd = "ps -axo pid:1,rss:1 --sort=%mem --no-headers"
    end

    # Transform result to metrics array
    def result_to_metrics()
      processes = []
      @result.each_line do |line|
        groups = line.match(/([^ ]*) (.*)/i).captures
        metric = Metric.new("#{@host}.#{groups[0]}",
                            groups[1],
                            "g")
        processes << metric
        @logger.debug(metric.format_before_send)
      end
      processes
    end
  end
end