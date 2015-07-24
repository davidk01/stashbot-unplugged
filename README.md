Inspired by [Stashbot](https://github.com/palantir/stashbot) for use in more distributed and less generous environments. Work in progress.

# Generating Package

```
vagrant up
vagrant ssh
sudo su
bash /vagrant/generate-package.sh
```

# Deploying Package

```
tar xf stashbot-unplugged.tar.gz
sudo useradd jenkins
sudo chown -R jenkins:jenkins jenkins
cd jenkins
sudo su jenkins -c "nohup JENKINS_HOME=$(pwd) java -jar jenkins.war &"
```

# Connecting to Stash Repositories
Once the package is deployed and Jenkins is up and running there are two pieces of configuration that need to be set before integrating with Stash: Stash credentials that give read access to the relevant repositories, Jenkins credentials for triggering jobs when PRs are created.

Once those two pieces of configuration are in place connecting things to Stash is just a matter of running `pr-verify-maker` job that comes with the package. 

The job is parametrized so the relevant bits of information will need to be filled in. The most obvious is the HTTP(s) URL of the repository. This is the repository that verification jobs will be running against and is also where `scripts/verify.sh` is assumed to live. Next is the Stash credentials of the user that has read access to the above repository. The latest Jenkins git plugin uses credentials for accessing HTTP(s) git repositories. These credentials are also used to comment on the status of PRs with the status of `scripts/verify.sh`. For initial bootstrapping we need the username/password of the Jenkins user so that we can create the PR watcher and verify jobs for the given repository by making a POST request to the Jenkins API. Finally there is another credentials parameter that is the username/password for the Jenkins user as a Jenkins credential object. This one is used from the PR watcher job to trigger the verification job whenever PRs change or new ones show up.

Once the `pr-verify-maker` successfully completes there will be two new jobs in the Jenkins instance called `${project}-${repo}-pr-watcher` and `${project}-${repo}-verify`. Both jobs are pretty much self-explanatory. The PR watcher job runs every 5 minutes and goes through any open PRs to see if the verification job has been triggered for it by checking the comments. If the verification job has not been triggered then it triggers it and moves on to the next open PR until all open PRs have been exhausted. The triggered verification jobs will report about the pass/fail status of the job by making a comment with a link to the job that made the comment.

The above gives us 90% of the functionality that Stashbot has. We lose the ability to push from Stash because everything happens from Jenkins so the only option is polling. Consequently it is not as scalable as Stashbot because when there are a significant number of PR watcher jobs it puts a lot of stress on the Stash instance hosting those repositories. Grabbing PRs and comments every 5 minutes even with jitter can put significant strain on Stash.

# Current Functionality
So far the only supported functionality is to run `scripts/verify.sh` and then comment back on the relevant PR in Stash about the status of the job with a link back to the Jenkins job. Next step is to add support for `scripts/publish.sh`.
