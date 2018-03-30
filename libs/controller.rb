require 'logger'
require_relative 'statsd'
require_relative 'metric'
require_relative 'worker'

module Monitoring
  class Controller
    def initialize(host_groups:,
                   ssh_opts:,
                   log_level: "INFO")
      @host_groups  = host_groups
      @ssh_opts     = ssh_opts
      @threads      = []
      @logger       = Logger.new(STDOUT)
      @logger.level = Logger.const_get(log_level)

      @logger.info("Controller created")
    end

    # Run Monitoring
    def run(worker_names)
      @threads = []
      @logger.info("Running threads on remote hosts...")
      @host_groups.each do |host_group|
        host_group[:hosts].each do |host|
          @threads << Thread.new {
            statsd_client = StatsD.new(host_group[:statsd], @logger)
            # Run all Workers
            workers = []
            worker_names.each do |worker_name|
              worker_class = Module.const_get("Monitoring::#{worker_name}")
              worker = worker_class.new(host, @ssh_opts, @logger).run
              workers << worker
            end
            metrics = sum_worker_results(workers)
            metrics.each { |metric| statsd_client.send(metric) }
            @logger.debug("Host \"#{host}\" completed work")
          }
        end
      end
      @threads.each { |thr| thr.join }
      @logger.info("Work completed")
    end

    # Sum up metrics from all workers
    def sum_worker_results(workers)
      metrics = []
      workers.each do |worker|
        metrics << worker.result_to_metrics
      end
      metrics.flatten
    end
  end
end