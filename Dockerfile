FROM python:3.7-stretch

# OS dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
	apt-get install -y sudo default-jdk-headless scala openssh-server openssh-client

RUN echo "spark ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "AllowUsers spark" >> /etc/ssh/sshd_config

RUN useradd -ms /bin/bash spark && \
	mkdir /usr/local/spark && \
	chown spark:spark /usr/local/spark
USER spark
WORKDIR /usr/local/spark

RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa && \
	more ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN wget -q http://it.apache.contactlab.it/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz && \
	tar -xzvf spark-2.4.4-bin-hadoop2.7.tgz && \
	mv spark-2.4.4-bin-hadoop2.7/* . && \
	rm spark-2.4.4-bin-hadoop2.7.tgz && \
	rm -rf spark-2.4.4-bin-hadoop2.7

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
ENV PYSPARK_PYTHON=python
ENV SHELL=/bin/bash
ENV PATH=$SPARK_HOME/bin:$PATH

COPY entrypoint.sh .

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
