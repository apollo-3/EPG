require 'logger'
require_relative 'statsd'
require_relative 'metric'
require_relative 'worker'

module Monitoring
  class Controller
    def initialize(hosts:,
                   user:,
                   key:,
                   statsd_host:,
                   statsd_port:,
                   log_level: "INFO")
      @hosts        = hosts
      @user         = user
      @key          = key
      @statsd_host  = statsd_host
      @statsd_port  = statsd_port
      @threads      = []
      @logger       = Logger.new(STDOUT)
      @logger.level = Logger.const_get(log_level)

      @logger.info("Controller created")
    end

    # Run Monitoring
    def run()
      @threads = []
      @logger.info("Running threads on remote hosts...")
      @hosts.each do |host|
        @threads << Thread.new {
          worker = PSWorker.new(host, @user, @key, @logger)
          worker.run
          Thread.current[:result] = worker.result_to_metrics
        }
      end
      @threads.each { |thr| thr.join }
    end

    # Send metrics to a backend-server
    def send_metrics
      @logger.info("Sending metrics...")
      statsd_client = StatsD.new(@statsd_host, @statsd_port, @logger)
      read_results.each do |metric|
        statsd_client.send(metric)
      end
    end

    private
    # Make metric array from thread execution results
    def read_results
      results = []
      @threads.each do |thr|
         thr[:result].each do |metric|
           results << metric
         end
      end
      results
    end
  end
end