module Monitoring
  class Handler
    def self.data_to_metrics(data)
      processes = []
      data.each_line do |line|
        groups = line.match(/([^ ]*) (.*)/i).captures
        processes << Metric.new(groups[0], groups[1], "c")
      end
      processes
    end
  end
end