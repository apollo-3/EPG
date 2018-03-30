require_relative 'libs/controller'

load './config.rb'

controller = Monitoring::Controller.new(host_groups: CONFIG[:host_groups],
                                        ssh_opts:    CONFIG[:ssh_opts],
                                        log_level:   CONFIG[:log_level])
controller.run(["PSWorker"])