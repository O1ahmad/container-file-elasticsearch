<p><img src="https://avatars1.githubusercontent.com/u/12563465?s=200&v=4" alt="OCI logo" title="oci" align="left" height="70" /></p>
<p><img src="https://seeklogo.com/images/E/elasticsearch-logo-C75C4578EC-seeklogo.com.png" alt="elasticsearch logo" title="elasticsearch" align="right" height="60" /></p>

Container File :mag_right: :high_brightness: Elasticsearch
=========
![GitHub release (latest by date)](https://img.shields.io/github/v/release/0x0I/container-file-elasticsearch?color=yellow)
[![Build Status](https://travis-ci.org/0x0I/container-file-elasticsearch.svg?branch=master)](https://travis-ci.org/0x0I/container-file-elasticsearch)
[![Docker Pulls](https://img.shields.io/docker/pulls/0labs/0x01.elasticsearch?style=flat)](https://hub.docker.com/repository/docker/0labs/0x01.elasticsearch)
[![License: MIT](https://img.shields.io/badge/License-MIT-blueviolet.svg)](https://opensource.org/licenses/MIT)

**Table of Contents**
  - [Supported Platforms](#supported-platforms)
  - [Requirements](#requirements)
  - [Environment Variables](#environment-variables)
      - [Config](#config)
      - [Launch](#launch)
  - [Dependencies](#dependencies)
  - [Example Run](#example-run)
  - [License](#license)
  - [Author Information](#author-information)

Container file that installs, configures and launches Elasticsearch: a real-time distributed search and analytics engine.

##### Supported Platforms:
```
* Redhat(CentOS/Fedora)
* Ubuntu
* Debian
```

Requirements
------------

None

Environment Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _config_
* _launch_

#### Config

#### Config

Using this image, configuration of `elasticsearch` is expressed within 3 forms:
- `elasticsearch.yml` file for configuring Elasticsearch
- `log4j2.properties` file for configuring Elasticsearch logging
- `$ES_JAVA_OPTS` environment variables for configuring Elasticsearch JVM settings

The location of these configuration files within a container is based on an `$ES_HOME` environment variable, set during image build and defaulting to `/opt/elasticsearch`.

For additional details and to get an idea how each config should look, reference Elastic's official [configuration](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html) documentation.

_The following variables can be customized to manage the location and content of these configurations:_

Each configuration applied to the operational behavior of the server can be expressed using environment variables prefixed with `CONFIG_` organized according to the following:
* **storage paths** - settings related to locations of runtime variable data (e.g. logs and indices data)
* **node role/profile policy** - [settings](https://github.com/elastic/elasticsearch/blob/master/docs/reference/modules/node.asciidoc) which manage a node's role and operational responsibilities within a cluster
* **cluster** - controls cluster allocation, logging, metadata and miscellaneous management [settings](https://github.com/elastic/elasticsearch/blob/master/docs/reference/modules/cluster.asciidoc)
* **discovery** - [settings](https://github.com/elastic/elasticsearch/blob/master/docs/reference/modules/discovery.asciidoc) responsible for discovering nodes, electing a master, forming a cluster, and publishing the cluster state changes
* **network** - network based [settings](https://github.com/elastic/elasticsearch/blob/master/docs/reference/modules/network.asciidoc) defining how an `elasticserch` instance communicates over a network

`$CONFIG_<config-property> = <property-value (string)>` **default**: *None*

* Any configuration setting/value key-pair supported by `elasticsearch` should be expressible within each `CONFIG_` environment variable and properly rendered within the associated `elasticsearch.yml`. **Note:** `<config-property>` along with the `property-value` specifications should be written as expected to be rendered within the associated *properties* config (**e.g.** `CONFIG_node.name=example_node` or  `CONFIG_network.host=0.0.0.0`).

Furthermore, configuration is not constrained by hardcoded author defined defaults or limited by pre-baked templating. If the config section, setting and value are recognized by your `Elasticsearch` version, :thumbsup: to define within an environnment variable according to the following syntax.

  `<config-property>` -- represents a specific configuration property to set:

  ```bash
  # Property: discovery.seed_hosts (peer nodes in target cluster likely to be live and contactable for seeding the discovery process)
  CONFIG_discovery.seed_hosts=<property-value>
  ```

  `<property-value>` -- represents property value to configure:
  ```bash
  # Property: discovery.seed_hosts
  # Value: list of additional peers resolved by hostname ['es1.cluster.domain', 'es2.cluster.domain']
  CONFIG_discovery.seed_hosts=['es1.cluster.domain', 'es2.cluster.domain']
  ```

  A list of configurable *Elasticsearch* settings can be found [here](https://github.com/elastic/elasticsearch/tree/master/docs/reference).

#### Launch

Running a `kafka` broker is accomplished utilizing official **Kafka** binaries, obtained from Apache Kafka's official downloads [site](https://kafka.apache.org/downloads). The execution profile of a *Kafka* broker is primarily managed via its `server.properties` configuration though, due to its dependency on the *Zookeeper* key-value store service, _the following variable(s) can be customized to manage the launch of a local ZK instance to meet this dependency, provided a more dedicated and robust solution is not available._

`$SETUP_ZK: <defined/true | undefined/empty-string>` (**default**: *undefined*)
- whether to launch a local *Zookeeper* instance. **note:** any setting of this variable registers as `true` to setup a local *Zookeeper* instance.

Dependencies
------------

None

Example Run
----------------
default example:
```
podman run --env SETUP_ZK=true 0labs/0x01.kafka:2.4.0_centos-7
```

adjust broker identification details:
```
podman run --env SETUP_ZK=true \
           --env CONFIG_broker.id=100 \
           --env CONFIG_advertised.host.name=kafka1.cluster.net \
           0labs/0x01.kafka:2.4.0_centos-7
```

launch Kafka broker connecting to existing remote Zookeeper cluster and customize connection parameters:
```
podman run --env CONFIG_zookeeper.connect=111.22.33.4:2181 \
           --env CONFIG_zookeeper.connection.timeout.ms=30000 \
           --env CONFIG_zookeeper.max.in.flight.requests=30 \
           0labs/0x01.kafka:2.4.0_centos-8
```

setup local zookeeper instance and modify its connection parameters:
```
podman run --env SETUP_ZK=true \
           --env ZKCONFIG_clientPort=2182 \
           --env ZKCONFIG_maxClientCnxns=10 \
           --env ZKCONFIG_admin.serverPort=8085 \
           --env CONFIG_zookeeper.connect=127.0.0.1:2182 \
           0labs/0x01.kafka:2.4.0_fedora-31
```

update Kafka commit log directory and parameters in addition to providing a named volume for storage persistence:
```
podman run --env CONFIG_log.dirs=/mnt/data/kafka \
           --env CONFIG_log.flush.interval.ms=3000 \
           --env CONFIG_log.retention.hours=168 \
           --env CONFIG_zookeeper.connect=zk1.cluster.net:2181 \
           --volume kafka_data:/mnt/data/kafka
           0labs/0x01.kafka:2.4.0_ubuntu:19.04
```

License
-------

MIT

Author Information
------------------

This Containerfile was created in 2020 by O1.IO.
