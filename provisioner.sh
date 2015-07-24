#!/bin/bash
set +x
# Need java for testing so might as well install it
yum -y install java-1.8.0-openjdk git vim maven tmux
# Copy the structure into place
cp -r /vagrant/jenkins .
# Some validation
if [[ ! -e jenkins ]]; then
  echo "Need jenkins directory to do anything."
  exit 1
fi
# Grab jq
if [[ ! -e jenkins/jq ]]; then
  pushd jenkins
  wget http://stedolan.github.io/jq/download/linux64/jq
  chmod +x jq
  popd
fi
# Install jenkins along with a bunch of plugins
echo "Grabbing jenkins.war"
if [[ ! -e jenkins/jenkins.war ]]; then
  pushd jenkins
  wget https://updates.jenkins-ci.org/latest/jenkins.war
  popd
fi
# Make the plugin directory
mkdir -p jenkins/plugins
# Need the workflow plugin source, for some reason can not install with hpi
git clone https://github.com/jenkinsci/workflow-plugin.git
# Compile the plugin and move *.hpi into place
pushd workflow-plugin
mvn -DskipTests clean install
find ./ -maxdepth 3 -iname *.hpi | xargs -I% cp % ../jenkins/plugins/
popd
# Download some more necessary plugins
pushd jenkins/plugins
echo "Grabbing plugins"
wget -q http://updates.jenkins-ci.org/latest/git.hpi
wget -q http://updates.jenkins-ci.org/latest/scm-api.hpi
wget -q http://updates.jenkins-ci.org/latest/credentials.hpi
wget -q http://updates.jenkins-ci.org/latest/git-client.hpi
wget -q http://updates.jenkins-ci.org/latest/ssh-credentials.hpi
wget -q http://updates.jenkins-ci.org/latest/postbuild-task.hpi
wget -q http://updates.jenkins-ci.org/latest/credentials-binding.hpi
wget -q http://updates.jenkins-ci.org/latest/plain-credentials.hpi
wget -q http://updates.jenkins-ci.org/latest/durable-task.hpi
wget -q http://updates.jenkins-ci.org/latest/git-server.hpi
popd
