require_relative 'libs/controller'

load './config.rb'

controller = Monitoring::Controller.new(hosts:       CONFIG[:hosts],
                                        user:        CONFIG[:ssh][:user],
                                        key:         CONFIG[:ssh][:key],
                                        statsd_host: CONFIG[:statsd][:host],
                                        statsd_port: CONFIG[:statsd][:port],
                                        log_level:   CONFIG[:log_level])
controller.run
controller.send_metrics