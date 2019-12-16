#!/bin/bash
# Initial installation setup for Amazon EC2 instances.
# Must be run in sudo mode.

yum update

# Install Java8

## Latest JDK8 version is JDK8u141 released on 19th July, 2017.

BASE_URL_8=http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141

platform="-linux-x64.rpm"

JDK_VERSION=`echo $BASE_URL_8 | rev | cut -d "/" -f1 | rev`

wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "${BASE_URL_8}${platform}"

rpm -i ${JDK_VERSION}${platform}

echo "export JAVA_HOME=/usr/java/default" >> /home/ec2-user/.bashrc
export JAVA_HOME=/usr/java/default


# Ensure correct versions of Java are used
echo "Important: Set to Java 8"
/usr/sbin/alternatives --config java
/usr/sbin/alternatives --config javac

# Install ant
wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.0-bin.tar.gz
tar xzf apache-ant-1.9.0-bin.tar.gz
mv apache-ant-1.9.0 /usr/local/apache-ant
echo 'export ANT_HOME=/usr/local/apache-ant' >> /home/ec2-user/.bashrc
echo 'export PATH=$PATH:/usr/local/apache-ant/bin' >> /home/ec2-user/.bashrc
export ANT_HOME=/usr/local/apache-ant
export PATH=$PATH:/usr/local/apache-ant/bin

# Install other dependencies
yum install svn
yum install patch
yum install gcc
yum install cpan
cpan DBI
cpan DBD:CSV

# Install Defects4J
git clone https://github.com/rjust/defects4j.git
project_root=$PWD
cd defects4j
./init.sh
export PATH=$PATH:/home/ec2-user/defects4j/framework/bin
echo 'export PATH=$PATH:/home/ec2-user/defects4j/framework/bin' >> /home/ec2-user/.bashrc
cd $project_root

# Replace files
cp lib/evosuitefit-1.0.7.jar defects4j/framework/lib/test_generation/generation/evosuite-current.jar
cp lib/evosuitefit-standalone-runtime-1.0.7.jar defects4j/framework/lib/test_generation/runtime/evosuite-rt.jar
cp src/Project.pm defects4j/framework/core/Project.pm
cp src/run_evosuite.pl defects4j/framework/bin/run_evosuite.pl

echo "Please restart bash before proceeding"
