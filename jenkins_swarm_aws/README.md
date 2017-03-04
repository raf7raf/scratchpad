# Jenkins swarm provision and auto-configuration

Provision Jenkins swarm using Terraform and perform inline configuration to install Jenkins/Swarm plugin

## Production usage
This script is only intended to be used as an example and has not been production h
ardened.  Joining your Jenkins master to the public internet with no access control
 should not done, this is only to demonstrate the Jenkins Swarm functionality.

## Sizing Jenkins

By default this script will only provision free-tier eligable resources however it is imperitive that you dispose of the VM's after creating them as running multiple t2.micro instances will take you over the free tier.

In production environments it is likely you will require a minimum of a m4.large instance for the master and as many CPU's you can afford for the slaves.

Throwing more resources at Jenkins may not speed it up.  Benchmark, benchmark, benchmark!  [This is a great article about some of things you can do to speed up your Jenkis CI pipeline]<https://ashishparkhi.com/2014/07/27/on-a-quest-of-reducing-jenkins-ci-build-time/>

## Lifecycle management
You will want to make sure you are backing up important files in $JENKINS_HOME on the Jenkins master.  [The documenation for this is a good starting point]<https://wiki.jenkins-ci.org/display/JENKINS/Administering+Jenkins>

All build data is aggregated on the master therefore the lifecycle of a slave node can be considered transient and they can easily be created/destroyed as and when demand changes.

Public clouds also provide auto-scaling ability which is excellent for building up and tearing down slave instances when your CI pipeline has a predictable usage pattern.
