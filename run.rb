require_relative 'libs/controller'

load './config.rb'

controller = Monitoring::Controller.new(host_groups:     CONFIG[:host_groups],
                                        user:            CONFIG[:ssh][:user],
                                        key:             CONFIG[:ssh][:key],
                                        timeout:         CONFIG[:ssh][:timeout],
                                        log_level:       CONFIG[:log_level])
controller.run