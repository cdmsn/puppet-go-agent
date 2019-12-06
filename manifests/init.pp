# = Class: go_agent
#
# This Class manages a Go agent
#
# == Variables
#
# [*go_server*]
#   The url to the go server
#
# [*agent_key*]
#   The API key for the go server
#
# [*agent_resources*]
#   The resources the agent provides
#
# [*agent_environments*]
#   The environments the agent runs in
#
# == Usage
#
#   class { 'goagent':
# 	  agent_key       => 'my-key',
# 	  agent_resources => 'my-resources',
# 	  go_server       => "url"
# 	}
class goagent (
  $go_server,
  $agent_key,
  $agent_resources,
  $agent_environments
) inherits ::goagent::params {

  package { $::goagent::params::package_name:
    ensure => installed
  }

  file { "autoregister.properties":
    path    => "/var/lib/go-agent/config/autoregister.properties",
    mode    => '0700',
    owner   => 'go',
    content => template("goagent/autoregister.properties.erb"),
    require => Package[$::goagent::params::package_name],
  }

  file { "/etc/default/go-agent":
    mode    => '0700',
    owner   => 'go',
    content => template("goagent/default.erb"),
    require => Package[$::goagent::params::package_name],
  }

  service { $::goagent::params::service_name:
    ensure    => 'running',
    subscribe => File["autoregister.properties"],
  }
}
