#!/bin/bash
if [[ ! -e jenkins ]]; then
  echo "Did not see jenkins folder."
  exit 1
fi

# Copy files into place
cp /vagrant/*.xml jenkins/

# Generate tgz and copy it to /vagrant for distribution
tar -cvzf stashbot-unplugged.tar.gz jenkins
cp stashbot-unplugged.tar.gz /vagrant
