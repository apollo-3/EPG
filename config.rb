$CONFIG = {
  :ssh => {
    :user => "root",
    :key  => "~/.ssh/id_rsa",
    :cmd  => "ps -axo pid:1,vsz:1 --sort=%mem --no-headers"
  },
  :hosts => [
    "192.168.56.10",
    "192.168.56.10",
    "192.168.56.10"
  ],
  :prometheus => {
    :host => "192.168.56.10",
    :port => "9125"
  }
}