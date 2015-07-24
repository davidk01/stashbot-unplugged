#!/bin/bash
# Add the user
if [[ ! $(id jenkins) ]]; then
  useradd jenkins
  usermod -a -G sudo jenkins
fi
# Get the package if we don't have the folder ready to go
if [[ ! -e /home/jenkins/jenkins ]]; then
  su -l jenkins -c 'wget "https://bintray.com/artifact/download/davidk01/generic/stashbot-unplugged.tar.gz"'
  su -l jenkins -c 'tar xf stashbot-unplugged.tar.gz'
  su -l jenkins -c 'mkdir bin'
  su -l jenkins -c 'cd jenkins && cp jq ~/bin'
  su -l jenkins -c 'cd jenkins; export JENKINS_HOME=/home/jenkins/jenkins; nohup java -jar jenkins.war --httpPort=4442 &'
fi
# Make sure it is started in case there is a restart and Jenkins isn't running
if [[ ! $(ps aux | grep jenkins | grep -v grep) ]]; then
  su -l jenkins -c 'cd jenkins; export JENKINS_HOME=/home/jenkins/jenkins; nohup java -jar jenkins.war --httpPort=4442 &'
fi
