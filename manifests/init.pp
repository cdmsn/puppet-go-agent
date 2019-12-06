# = Class: goagent
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
  $agent_environments,
  $agent_version
) inherits ::goagent::params {

  apt::source { 'gocd':
    comment  => 'Repor for GoCD',
    location => 'http://download.gocd.org',
    release  => '',
    repos     => '/',
    key      => {
       id      => '322259C82D3082B3E32AEC2ED8843F288816C449',
       server  => 'download.gocd.org',
       source  => 'https://download.gocd.org/GOCD-GPG-KEY.asc'
    },
    include  => {
      'deb' => true,
    },
  } ->
  package { $::goagent::params::package_name:
    ensure => $agent_version,
  }

  file { "/var/lib/go-agent/config":
    ensure => 'directory',
    owner  => 'go',
    require => Package[$::goagent::params::package_name]
  }
  
  file { "autoregister.properties":
    path    => "/var/lib/go-agent/config/autoregister.properties",
    mode    => '0700',
    owner   => 'go',
    content => template("goagent/autoregister.properties.erb"),
    require => File["/var/lib/go-agent/config"]
  }

  file { "/etc/default/go-agent":
    mode    => '0700',
    owner   => 'go',
    content => template("goagent/default.erb"),
    require => Package[$::goagent::params::package_name],
  }

  file { "/usr/share/go-agent/wrapper-config/wrapper-properties.conf":
    mode    => '0700',
    owner   => 'go',
    content => template("goagent/wrapper-properties.conf.erb"),
    require => Package[$::goagent::params::package_name],
  }

  service { $::goagent::params::service_name:
    ensure    => 'running',
    subscribe => File["autoregister.properties"],
    require   => File["/etc/default/go-agent"]
  }
}
