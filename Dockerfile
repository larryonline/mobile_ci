FROM icojo/oracle-jdk-1.8

MAINTAINER larry <larry@rrceo.com>

ENV REFRESHED_AT 2015-9-24

# add apt-get mirror for china internet environment
ADD ./source.list.mirror /etc/apt/sources.list

# install apps
RUN dpkg --add-architecture i386
RUN apt-get update

# add x32 support
RUN apt-get install -qqy libc6:i386 libstdc++6:i386 lib32z1 libncurses5:i386 gcc-multilib

# add support software
RUN apt-get install -qqy curl git gradle

# install rvm environment
RUN \curl -sSL https://get.rvm.io | bash -s stable
# use ruby.taobao.com mirror instead the official source
RUN sed -i .bak 's!cache.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db

# install ruby use rvm
RUN rvm install ruby

# use ruby.taobao.org mirror instead rubygems.org
RUN gem sources --remove https://rubygems.org/
RUN gem sources --add https://ruby.taobao.org/

# install calcabash-android
RUN gem install calabash-android

ENV JENKINS_HOME /opt/jenkins/data
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org

# add jenkins.war
ADD ./jenkins.war /opt/jenkins/jenkins.war

# update Timezone
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# start script
ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# add release key
ADD ./com.rrceo.android.jks $JENKINS_HOME/com.rrceo.android.jks


EXPOSE 8080

CMD [ "/usr/local/bin/start.sh" ]
