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
  
##### Log4j Config

Elasticsearch's logging facility is managed via [Log4j](https://logging.apache.org/log4j/2.x/), a logging service/framework built under the Apache project; with its configuration defined in a `log4j.properties` file located underneath Its main `$ES_HOME/config/` directory by default. As with other configuration mechanisms supported by this image, each configuration can be expressed as environment variables prefixed with `LOG4J_`.

`$LOG4J_<config-property> = <property-value (string)>` **default**: *none*

See [here](https://github.com/elastic/elasticsearch/blob/master/distribution/src/config/log4j2.properties) for an example configuration file and list of supported settings.

##### JVM Options

Elasticsearch uses the following environment variable to manage various aspects of its JVM environment:

`$ES_JAVA_OPTS = <mem-heap-mgmt-settings (string)>` **default**: *None*

* Adjust general memory management options used during node operation (e.g. `-Xmx256M -Xms256M`).

See [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/jvm-options.html) for more details and [here](https://github.com/elastic/elasticsearch/blob/master/distribution/src/config/jvm.options) for an example of available options.

#### Launch

Running an `elasticsearch` node is accomplished utilizing official **Elasticsearch** binaries published and available [here](https://www.elastic.co/downloads/elasticsearch). Launched subject to the configuration and execution potential provided by the underlying application, an `elasticsearch` node can be set to adhere to system administrative policies right for your environment and organization.

_The following variables can be customized to manage Elasticsearch's execution profile/policy:_

`$EXTRA_RUN_ARGS: <elasticsearch-cli-options>` (**default**: *NONE*)
- list of `elasticsearch` commandline arguments to pass to the binary at runtime for customizing launch.

Supporting full expression of `elasticsearch`'s cli, this variable enables the role of target hosts to be customized according to the user's specification; whether to specify a particular process id (PID) file for process management, running a node in a verbose or silent logging mode or passing an assortment of configuration operation overrides.

  A list of available command-line options can be found [here](https://gist.github.com/0x0I/f9890f486ff215cfc39642c4d7eccc01).

##### Examples

  Turn off or enhance standard output/error streams logging in console:
  ```bash
  EXTRA_RUN_ARGS=--quiet  # off
  # ...or...
  EXTRA_ARGS=--verbose  # on++
  ```

  Enhance logging and debugging capabilities for troubleshooting issues:
  ```bash
  EXTRA_ARGS="--pid /path/to/pid" # creates specific pid file in the specified path on start 
  ```

  Update node identity:
  ```
  EXTRA_ARGS="-E node.name=my-example-node -E cluster.name=my-example-cluster"
  ```

Dependencies
------------

None

Example Run
----------------
default example:
```
podman run --publish 9200:9200 0labs/0x01.elasticsearch:7.6.1_centos-7
```

provision hybrid master/data node with customized data and logging directories:
```
podman run --env CONFIG_cluster.name=example-cluster \
           --env CONFIG_node.master=true \
           --env CONFIG_node.data=true \
           --env CONFIG_path.data=/mnt/data/elasticsearch \
           --env CONFIG_path.logs=/mnt/logs/elasticsearch \
           --volume es_data:/mnt
           0labs/0x01.elasticsearch:7.6.1_centos-7
```

adjust JVM heap settings and enable verbose logging for cluster debugging/troubleshooting:
```
podman run --env ES_JAVA_OPTS='-Xms16g -Xmx16g' \
           --env LOG4J_logger.action.name=org.elasticsearch.action \
           --env LOG4J_logger.action.level=debug \
           --env EXTRA_RUN_ARGS=--verbose \
           0labs/0x01.elasticsearch:7.6.1_centos-7
```

License
-------

MIT

Author Information
------------------

This Containerfile was created in 2020 by O1.IO.
