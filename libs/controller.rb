require 'logger'
require_relative 'statsd'
require_relative 'metric'
require_relative 'worker'

module Monitoring
  class Controller
    def initialize(host_groups:,
                   user:,
                   key:,
                   timeout:,
                   log_level: "INFO")
      @host_groups     = host_groups
      @user            = user
      @key             = key
      @timeout         = timeout
      @threads         = []
      @logger          = Logger.new(STDOUT)
      @logger.level    = Logger.const_get(log_level)

      @logger.info("Controller created")
    end

    # Run Monitoring
    def run()
      @threads = []
      @logger.info("Running threads on remote hosts...")
      @host_groups.each do |host_group|
        host_group[:hosts].each do |host|
          @threads << Thread.new {
            worker = PSWorker.new(host,
                                  @user,
                                  @key,
                                  @timeout,
                                  @logger)
            worker.run
            statsd_client = StatsD.new(host_group[:statsd][:host],
                                       host_group[:statsd][:port],
                                       @logger)
            worker.result_to_metrics.each do |metric|
              statsd_client.send(metric)
            end
            @logger.debug("Host \"#{host}\" completed work")
          }
        end
      end
      @threads.each { |thr| thr.join }
      @logger.info("Work completed")
    end
  end
end