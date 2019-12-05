# cdmsn/go-agent

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with cdmsn/go-agent](#setup)
    * [What cdmsn/go-agent affects](#what-cdmsn-go-agent-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with cdmsn/go-agent](#beginning-with-cdmsn/go-agent)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module will install all needed packages for using go-agent and fonfigures mounted shares

## Setup

### What cdmsn/go-agent affects

This module will install and manage a go agent.

### Setup Requirements

This module expects that the agent can be installed via apt.
As this module needs secrets to connect to the go server, you should use something like Blackbox to encrypt the hiera files.

### Beginning with cdmsn/go-agent

Clone this module and install in puppet module folder

## Usage

### Manifest
To use module in manifest use:
```
class { 'go_agent':
  agent_key          => 'the-key-for-the-agent',
  agent_resources    => 'the-agent-resources',
  agent_environments => 'env1,env2,en3',
  go_server          => 'ip'
}
```
Don't check secrets into VCS. Use something like Blackbox


### Hiera
In hiera use:
```
go_agent::agent_key: the-key-for-the-agent
go_agent::agent_resources: the-agent-resources
go_agent::agent_environments: env1,env2,en3
go_agent::go_server: ip-of-go-server
```
Don't check secrets into VCS. Use something like Blackbox


## Reference

### Class: go_agent
| Parameter | Type | Description | Default |
|---|---|---|---|
| agent_key       | String | The key for the agent | |
| agent_resources | String | The resources the agent provides |  |
| agent_environments | String | The environmant the agent runs in | |
| go_server       | String | The ip to the go server | |
| java_home       | String | desc | "/usr/lib/jvm/java-7-openjdk-amd64/jre" |

## Limitations

Only tested on Ubuntu

## Development

clone and start coding...