require_relative 'ssh'

module Monitoring
  class Worker
    attr_reader :host, :result
    def initialize(host, ssh_opts, logger)
      @host     = host
      @ssh_opts = ssh_opts
      @cmd      = ""
      @result   = nil
      @logger   = logger
    end

    # Execute worker
    def run
      @result = SSH.new(@host,
                        @ssh_opts,
                        @cmd,
                        @logger).run
      self
    end

    # Transform result to metrics array
    def result_to_metrics() end
  end

  class PSWorker < Worker
    def initialize(host, ssh_opts, logger)
      super(host, ssh_opts, logger)
      @cmd = "ps -axo pid:1,rss:1 --sort=%mem --no-headers"
    end

    # Transform result to metrics array
    def result_to_metrics()
      processes = []
      @result.each_line do |line|
        groups = line.match(/([^ ]*) (.*)/i).captures
        metric = StatsDMetric.new(metric_details: {
          :host   => @host,
          :name   => groups[0],
          :values => {
            :main   => groups[1]
          },
          :type   =>  "g"})
        processes << metric
        @logger.debug("Collected metric \"#{metric.format_before_send}\"")
      end
      processes
    end
  end
end