FROM ubuntu
MAINTAINER Judit Acs
RUN apt-get update
RUN yes | apt-get install -y wget gcc python npm perl php5 git default-jdk
RUN cd
RUN git clone https://github.com/juditacs/wordcount.git
