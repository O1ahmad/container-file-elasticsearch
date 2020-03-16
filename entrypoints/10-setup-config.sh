#!/bin/bash

# Print all commands executed if DEBUG mode enabled
[ -n "${DEBUG:-""}" ] && set -x

config_dir="${ES_HOME}/config"
config_path="${ES_HOME}/config/elasticsearch.yml"

mkdir -p $config_dir

# Render server properties configuration
if env | grep CONFIG_ &>/dev/null; then
  # Add provisioning header
  echo "# Managed by 0xO1.IO" > $config_path
  echo >> $config_path

  for VAR in `env | sort -h`
  do
    if [[ "$VAR" =~ ^CONFIG_ ]]; then
      property_key=`echo "$VAR" | sed -r "s/CONFIG_(.*)=.*/\1/g" | tr _ .`
      # if section name contains a '.', obtain value from full ENV rather than parse
      if [[ $property_key == *.* ]] ; then
        echo "$property_key: $(echo $VAR | cut -d'=' -f2)" >> $config_path
      else
        property_value=`echo "CONFIG_${property_key}"`
        echo "$property_key: ${!property_value}" >> $config_path
      fi
      echo >> $config_path
    fi
  done
fi
