FROM ubuntu:14.04
MAINTAINER Judit Acs

# Core utilities and languges, concatenated into one operation to reduce layers
# No text editors or git, since we can directly edit mounted files in local folder
RUN apt-get update \
    && apt-get install -y wget curl time software-properties-common xdg-utils git \
       gcc g++ clang-3.6 \
       python perl mono-mcs golang-go lua5.2 \
       ghc cabal-install \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Latest Oracle 8 JDK for the JVM languages
RUN apt-add-repository -y ppa:webupd8team/java \
    && apt-key update \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && apt-get install -y oracle-java8-installer \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/oracle-jdk8-installer

# Julia
RUN apt-add-repository -y ppa:staticfloat/juliareleases \
    && apt-key update \
    && apt-get update \
    && apt-get install -y julia \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# PHP 
RUN apt-add-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --allow-unauthenticated php7.0-cli php5.6-cli \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN sudo apt-get install --yes nodejs

# Rust
RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh

# Scala
RUN wget www.scala-lang.org/files/archive/scala-2.11.7.deb \
    && dpkg -i scala-2.11.7.deb \
    && rm -f scala-2.11.7.deb

# Erlang + Elixir, might not need the apt-get update here?
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && rm -f erlang-solutions_1.0_all.deb \
    && apt-key update \
    && apt-get update \
    && apt-get install -y esl-erlang elixir \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# D
RUN wget http://downloads.dlang.org/releases/2.x/2.070.2/dmd_2.070.2-0_amd64.deb \
    && dpkg -i dmd_2.070.2-0_amd64.deb \
    && rm -f dmd_2.070.2-0_amd64.deb

# Ruby
RUN apt-add-repository ppa:brightbox/ruby-ng \
    && apt-key update \ 
    && apt-get update \
    && apt-get install -y ruby2.3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Clojure
RUN wget https://oss.sonatype.org/content/repositories/snapshots/org/clojure/clojure/1.9.0-master-SNAPSHOT/clojure-1.9.0-master-20160119.195127-1.jar -O clojure.jar

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LC_COLLATE C
ENV PYTHONIOENCODING utf-8
COPY scripts/as_user.sh /bin/as_user.sh
WORKDIR /wordcount