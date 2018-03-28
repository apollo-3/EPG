require 'socket'
require_relative 'libs/ssh'
require_relative 'libs/statsd'
require_relative 'libs/metric'
require_relative 'libs/handler'

module Monitoring
  load './config.rb'

  threads = []
  $CONFIG[:hosts].each do |host|
    threads << Thread.new {
      cmd = SSH.new(host, $CONFIG[:ssh][:user],
                          $CONFIG[:ssh][:key],
                          $CONFIG[:ssh][:cmd])
      Thread.current[:result] = Handler.data_to_metrics(cmd.run)
    }
  end
  threads.each { |thr| thr.join }
  prometheus_client = StatsD.new($CONFIG[:prometheus][:host],
                                 $CONFIG[:prometheus][:port])
  threads.each do |thr|
     thr[:result].each do |metric|
       # puts "#{metric.name} #{metric.value}"
       prometheus_client.send(metric.name,
                              metric.value,
                              metric.type)
     end
  end
end