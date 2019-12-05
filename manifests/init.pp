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
# [*java_home*]
#   Path to java, Defaults to '/usr/lib/jvm/java-7-openjdk-i386/jre'
#
# == Usage
#
#   class { 'go_agent':
# 	  agent_key       => 'my-key',
# 	  agent_resources => 'my-resources',
# 	  go_server       => "url",
# 	  java_home       => "/usr/lib/jvm/java-7-openjdk-amd64/jre"
# 	}
class go_agent (
  $go_server,
  $agent_key,
  $agent_resources,
  $agent_environments,
  $java_home = "/usr/lib/jvm/java-7-openjdk-i386/jre"
) inherits ::go_agent::params {
  package { "go-agent":
    ensure  => installed,
    require => [Package['openjdk-7-jre-headless'],],
  }

  if !defined(Package['openjdk-7-jre-headless']) {
    package { "openjdk-7-jre-headless": ensure => "7u79-2.5.5-0ubuntu0.14.04.2" }
  }

  file { "autoregister.properties":
    path    => "/var/lib/go-agent/config/autoregister.properties",
    mode    => '0700',
    owner   => 'go',
    content => template("go_agent/autoregister.properties.erb"),
    require => Package['go-agent'],
  }

  file { "/etc/default/go-agent":
    mode    => '0700',
    owner   => 'go',
    content => template("go_agent/default.erb"),
    require => Package['go-agent'],
  }

  service { 'go-agent':
    ensure    => 'running',
    subscribe => File["autoregister.properties"],
  }
}
