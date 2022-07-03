FROM dorowu/ubuntu-desktop-lxde-vnc:bionic AS rtmvnc_base
LABEL maintainer Kazuki Urabe <urabe0225@gmail.com>

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y dirmngr
RUN sh -c 'echo "deb http://openrtm.org/pub/Linux/ubuntu/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/rtm-latest.list'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4BCE106E087AFAC0
RUN apt-get update && \
    apt-get install -y gcc g++ make uuid-dev && \
    apt-get install -y libomniorb4-dev omniidl && \
    apt-get install -y openrtm-aist openrtm-aist-doc openrtm-aist-dev openrtm-aist-example && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

FROM rtmvnc_base AS rtmvnc_test
RUN apt-get update && apt-get install -y wget
#RUN apt-get install iputils-ping bc
WORKDIR /root
RUN wget https://raw.githubusercontent.com/OpenRTM/OpenRTM-aist/master/scripts/pkg_install_ubuntu.sh
RUN sh pkg_install_ubuntu.sh -l openrtp --yes

FROM rtmvnc_base AS rtmvnc_py
RUN apt-get update && \
    apt-get install python && \
    apt-get install python-omniorb-omg omniidl-python && \
    apt-get install openrtm-aist-python openrtm-aist-python-example