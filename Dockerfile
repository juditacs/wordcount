FROM ubuntu
MAINTAINER Judit Acs
RUN apt-get update
RUN yes | apt-get install -y wget curl gcc g++ nano python perl php5 git default-jdk time software-properties-common
RUN yes | apt-add-repository ppa:staticfloat/juliareleases
RUN yes | apt-get update
RUN yes | apt-get install julia
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN sudo apt-get install --yes nodejs
RUN cd
RUN git clone https://github.com/juditacs/wordcount.git
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV LC_COLLATE C
ENV PYTHONIOENCODING utf-8
