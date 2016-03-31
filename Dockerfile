FROM ubuntu:14.04
MAINTAINER Sam Van Oort and Judit Acs

# Builder and run environment for when you want to cover *MANY* languages
# Currently does C, C++, C#, Clojure, D, Erlang, Elixir, javascript (node.js), Julia
#   Go, Java, Lua, Perl, PHP, Python2, Python3, Rust, Scala

# Core utilities and languges, concatenated into one operation to reduce layers
# No text editors or git, since we can directly edit mounted files in local folder
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget curl time software-properties-common xdg-utils git \
       gcc g++ clang-3.6 \
       python perl mono-mcs golang-go lua5.2 \
       ghc cabal-install \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Latest Oracle 8 JDK for the JVM languages, massively stripped down
RUN apt-add-repository -y ppa:webupd8team/java \
    && apt-key update \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && apt-get install -y --no-install-recommends oracle-java8-installer \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/oracle-jdk8-installer \
    && rm -rf /opt/jdk/*src.zip \
           /usr/lib/jvm/java-8-oracle/missioncontrol \
           /usr/lib/jvm/java-8-oracle/visualvm \
           /usr/lib/jvm/java-8-oracle/*javafx* \
           /usr/lib/jvm/java-8-oracle/jre/lib/plugin.jar \
           /usr/lib/jvm/java-8-oracle/jre/lib/ext/jfxrt.jar \
           /usr/lib/jvm/java-8-oracle/jre/bin/javaws \
           /usr/lib/jvm/java-8-oracle/jre/lib/javaws.jar \
           /usr/lib/jvm/java-8-oracle/jre/lib/desktop \
           /usr/lib/jvm/java-8-oracle/jre/plugin \
           /usr/lib/jvm/java-8-oracle/jre/lib/deploy* \
           /usr/lib/jvm/java-8-oracle/jre/lib/*javafx* \
           /usr/lib/jvm/java-8-oracle/jre/lib/*jfx* \
           /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libdecora_sse.so \
           /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libprism_*.so \
           /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libfxplugins.so \
           /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libglass.so \
           /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libgstreamer-lite.so \
           /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libjavafx*.so \
           /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libjfx*.so

# Scala
RUN wget www.scala-lang.org/files/archive/scala-2.11.7.deb \
    && dpkg -i scala-2.11.7.deb \
    && rm -f scala-2.11.7.deb \
    && rm -rf /usr/share/doc/scala/

# Julia
RUN apt-add-repository -y ppa:staticfloat/juliareleases \
    && apt-key update \
    && apt-get update \
    && apt-get install -y --no-install-recommends julia \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN sudo apt-get install --yes nodejs

# Rust
RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh

# Erlang + Elixir, might not need the apt-get update here?
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && rm -f erlang-solutions_1.0_all.deb \
    && apt-key update \
    && apt-get update \
    && apt-get install -y --no-install-recommends esl-erlang elixir \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# D
RUN wget http://downloads.dlang.org/releases/2.x/2.070.2/dmd_2.070.2-0_amd64.deb \
    && dpkg -i dmd_2.070.2-0_amd64.deb \
    && rm -f dmd_2.070.2-0_amd64.deb

# Ruby
RUN apt-add-repository ppa:brightbox/ruby-ng \
    && apt-key update \ 
    && apt-get update \
    && apt-get install -y --no-install-recommends ruby2.3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# PHP 
RUN apt-add-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated php7.0-cli php5.6-cli \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Clojure
RUN wget https://oss.sonatype.org/content/repositories/snapshots/org/clojure/clojure/1.9.0-master-SNAPSHOT/clojure-1.9.0-master-20160119.195127-1.jar -O /usr/lib/clojure.jar \
    && chmod a+rx /usr/lib/clojure.jar

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LC_COLLATE C
ENV PYTHONIOENCODING utf-8
COPY scripts/as_user.sh /bin/as_user.sh
WORKDIR /allthelanguages