CONFIG = {
  # Information for SSH connection to remote hosts
  :ssh => {
    :user    => "root",
    :key     => "~/.ssh/id_rsa",
    :timeout => "5"
  },
  # List of remote hosts to gather metrics from
  :hosts => [
    "centos_host",
    "centos_host",
    "centos_host"
  ],
  # StatsD settings
  :statsd => {
    # Set to true if you have StatsD installed on each monitored box
    # and want to send metrics to them
    # Set to false if you send metrics to a dedicated StatsD instance for this
    # hosts group
    :per_host => false,
    :host     => "192.168.56.10",
    :port     => "9125"
  },
  :log_level => "INFO"
}