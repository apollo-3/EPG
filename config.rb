CONFIG = {
  :ssh => {
    :user => "root",
    :key  => "~/.ssh/id_rsa",
  },
  :hosts => [
    "192.168.56.10",
    "192.168.56.10",
    "192.168.56.10"
  ],
  :statsd => {
    :host => "192.168.56.10",
    :port => "9125"
  },
  :log_level => "INFO"
}