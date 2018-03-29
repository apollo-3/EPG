module Monitoring
  class Metric
    attr_reader :name, :value, :type
    def initialize(name, value, type)
      @name  = name
      @value = value
      @type  = type
    end

    # Format metric to statsd foramt string
    def format_before_send
      "#{@name}:#{@value}|#{@type}"
    end    
  end
end