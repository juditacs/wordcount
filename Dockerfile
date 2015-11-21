FROM ubuntu
MAINTAINER Judit Acs
RUN apt-get update
RUN yes | apt-get install -y wget gcc python npm perl php5 git default-jdk time
RUN cd
RUN git clone https://github.com/juditacs/wordcount.git
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV PYTHONIOENCODING="utf-8"
