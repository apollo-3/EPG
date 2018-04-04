module Monitoring
  class Metric
    attr_reader :host,
                :name
    def initialize(metric_details)
      @metric_details = metric_details
      @host           = metric_details[:host]
      @name           = metric_details[:name]
      @values         = metric_details[:values]
    end

    # Format metric, so receiving downstream could understand it
    def format_before_send() end

    # Get host prefox name
    def host_prefix_name
      "#{@host}.#{@name}"
    end
  end

  class StatsDMetric < Metric
    attr_reader :host,
                :name,
                :value,
                :type
    def initialize(metric_details:)
      super(metric_details)
      @value = metric_details[:values].first()[1]
      @type  = metric_details[:type]
    end

    # Format metric to statsd foramt string
    def format_before_send
      "#{@host}.#{@name}:#{@value}|#{@type}"
    end
  end
end