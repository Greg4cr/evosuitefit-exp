#!/bin/bash
# Initial installation setup for Ubuntu.
# Must be run in sudo mode.

# Install Java8

add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java8-installer

echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle/' >> $HOME/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/

# Ensure correct versions of Java are used
echo "Important: Set to Java 8"
/usr/sbin/alternatives --config java
/usr/sbin/alternatives --config javac

# Install ant
apt-get install ant
wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.0-bin.tar.gz
tar xzf apache-ant-1.9.0-bin.tar.gz
mv apache-ant-1.9.0 /usr/local/apache-ant
echo 'export ANT_HOME=/usr/local/apache-ant' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/local/apache-ant/bin' >> $HOME/.bashrc
export ANT_HOME=/usr/local/apache-ant
export PATH=$PATH:/usr/local/apache-ant/bin

# Install other dependencies
apt-get install make
apt-get install screen
apt-get install unzip
apt-get install git
apt-get install patch
apt-get install gcc
cpan DBI
cpan DBD:CSV

# Install Defects4J
git clone https://github.com/rjust/defects4j.git
project_root=$PWD
cd defects4j
./init.sh
export PATH=$PATH:/home/ec2-user/defects4j/framework/bin
echo 'export PATH=$PATH:/home/ec2-user/defects4j/framework/bin' >> $HOME/.bashrc
cd $project_root

# Replace files
cp lib/evosuitefit-1.0.7.jar defects4j/framework/lib/test_generation/generation/evosuite-current.jar
cp lib/evosuitefit-standalone-runtime-1.0.7.jar defects4j/framework/lib/test_generation/runtime/evosuite-rt.jar
cp src/Project.pm defects4j/framework/core/Project.pm
cp src/run_evosuite.pl defects4j/framework/bin/run_evosuite.pl

echo "Please restart bash before proceeding"
