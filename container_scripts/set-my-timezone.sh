#!/bin/bash

if [ -z "$TZ" ]; then
  echo "Timezone is not set. Using default timezone UTC"
else
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
fi
