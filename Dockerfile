FROM ubuntu:16.04

RUN DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y zlib1g-dev automake autoconf git \
		libtool subversion libatlas3-base ffmpeg python-pip \
		python-dev wget unzip && \
	apt-get clean

ADD ext /gentle/ext


RUN MAKEFLAGS=' -j8' cd /gentle/ext && \
	./install_kaldi.sh && \
	make #  && rm -rf kaldi *.o

ADD exp /gentle/exp

ADD . /gentle
RUN cd /gentle && ./install_deps.sh
RUN cd /gentle && pip install .

RUN cd /gentle/ext && make depend && make

EXPOSE 8765

VOLUME /gentle/webdata

# CMD cd /gentle && python serve.py
