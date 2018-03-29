require_relative 'ssh'

module Monitoring
  class Worker
    attr_reader :host, :result
    def initialize(host, user, key, timeout, logger)
      @host       = host
      @user       = user
      @key        = key
      @timeout    = timeout
      @cmd        = ""
      @result     = nil
      @logger     = logger
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
        metric = Metric.new(host:  @host,
                            name:  groups[0],
                            value: groups[1],
                            type:  "g")
        processes << metric
        @logger.debug("Collected metric \"#{metric.format_before_send}\"")
      end
      processes
    end
  end
end