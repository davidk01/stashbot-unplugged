#!/bin/bash

# Make sure jq is available in /bin
if [[ ! -e /bin/jq ]]; then
  echo "Make sure jq binary has been copied to /bin."
  echo "It is shipped with this package and should be in current directory."
  exit 1
fi

# We need java obviously
if [[ ! $(which java) ]]; then
  echo "Jenkins needs java to work. The plugins were compiled with jdk1.8 on CentOS 7."
  echo "Run 'sudo yum install -y java-1.8.0-openjdk' or use your own preferred method."
  exit 1
fi

# Make sure jenkins user exists
if [[ ! $(id jenkins) ]]; then
  echo "We need jenkins user to run the jenkins.war file."
  echo "Add the user with 'useradd jenkins'"
  exit 1
fi

# Getting this far means we're good to go
echo "Make sure everything in current folder is owned by jenkins:jenkins"
echo "otherwise you'll get weird ownership errors."

# Tell them how to start but don't actually start anything
echo "To start Jenkins run 'JENKINS_HOME=\$\(pwd\) nohup java -jar jenkins.war &'."
