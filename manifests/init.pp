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
#   class { 'go_agent':
# 	  agent_key       => 'my-key',
# 	  agent_resources => 'my-resources',
# 	  go_server       => "url"
# 	}
class go_agent (
  $go_server,
  $agent_key,
  $agent_resources,
  $agent_environments
) inherits ::go_agent::params {

  package { $::go_agent::params::package_name:
    ensure => installed
  }

  file { "autoregister.properties":
    path    => "/var/lib/go-agent/config/autoregister.properties",
    mode    => '0700',
    owner   => 'go',
    content => template("go_agent/autoregister.properties.erb"),
    require => Package[$::go_agent::params::package_name],
  }

  file { "/etc/default/go-agent":
    mode    => '0700',
    owner   => 'go',
    content => template("go_agent/default.erb"),
    require => Package[$::go_agent::params::package_name],
  }

  service { $::go_agent::params::service_name:
    ensure    => 'running',
    subscribe => File["autoregister.properties"],
  }
}
