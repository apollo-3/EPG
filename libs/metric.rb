module Monitoring
  class Metric
    attr_reader :host, :name, :value, :type
    def initialize(host:,
                   name:,
                   value:,
                   type:)
      @host  = host
      @name  = name
      @value = value
      @type  = type
    end

    # Format metric to statsd foramt string
    def format_before_send
      "#{@host}.#{@name}:#{@value}|#{@type}"
    end
  end
end