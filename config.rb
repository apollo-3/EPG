CONFIG = {
  # Information for SSH connection to remote hosts
  :ssh => {
    :user    => "root",
    :key     => "~/.ssh/id_rsa",
    :timeout => "5"
  },
  # List of remote hosts to gather metrics from
  :host_groups => [
                    {:hosts  => ["centos_host",
                                 "centos_host",
                                 "centos_host"],
                     :statsd => {:host => "192.168.56.10",
                                 :port => "9125"}}
  ],
  :log_level => "DEBUG"
}