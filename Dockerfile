FROM ubuntu:14.04
MAINTAINER Judit Acs
RUN apt-get update
RUN yes | apt-get install -y wget curl gcc g++ nano python perl git default-jdk time software-properties-common mono-mcs ghc cabal-install
RUN yes | apt-add-repository ppa:ondrej/php
RUN yes | apt-add-repository ppa:staticfloat/juliareleases
RUN yes | apt-get update
RUN yes | apt-get install php7.0-cli php5.6-cli
RUN yes | apt-get install julia
RUN yes | apt-get install golang-go
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN sudo apt-get install --yes nodejs
RUN cabal update
RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh
RUN wget www.scala-lang.org/files/archive/scala-2.11.7.deb
RUN dpkg -i scala-2.11.7.deb
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install -y esl-erlang elixir
RUN git clone https://github.com/juditacs/wordcount.git
RUN wget https://oss.sonatype.org/content/repositories/snapshots/org/clojure/clojure/1.9.0-master-SNAPSHOT/clojure-1.9.0-master-20160119.195127-1.jar -O wordcount/clojure.jar
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LC_COLLATE C
ENV PYTHONIOENCODING utf-8
