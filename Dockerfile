FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y software-properties-common

RUN apt-get install -y python

RUN apt-get install -y curl unzip

RUN curl -o /root/get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN python /root/get-pip.py

RUN curl -o /root/elementtree.zip http://effbot.org/media/downloads/elementtree-1.2.7-20070827-preview.zip

WORKDIR /root
RUN unzip elementtree.zip

WORKDIR /root/elementtree-1.2.7-20070827-preview

RUN python setup.py install

RUN pip install setuptools
RUN pip install uuid
RUN pip install llbase
RUN pip install WebOb
RUN pip install wsgiref
RUN pip install eventlet==0.9.17
RUN pip install pyOpenssl

RUN apt-get install -y mercurial
RUN apt-get install -y patch
RUN apt-get install -y sudo
RUN apt-get install -y psmisc

RUN mkdir /root/hg

WORKDIR /root/hg

RUN hg clone https://enus_linden@bitbucket.org/lindenlab/pyogp.apps
RUN hg clone https://enus_linden@bitbucket.org/lindenlab/pyogp.lib.base
RUN hg clone https://enus_linden@bitbucket.org/lindenlab/pyogp.lib.client-maint

ADD patches/template_parser.patch /root/template_parser.patch
ADD patches/data_packer.patch /root/data_packer.patch
WORKDIR /root/hg/pyogp.lib.base/pyogp/lib/base/message
RUN patch -p0 </root/template_parser.patch
RUN patch -p0 </root/data_packer.patch
WORKDIR /root/hg/pyogp.lib.base
RUN python setup.py install

ADD patches/appearance.patch /root/appearance.patch
ADD patches/login.patch /root/login.patch
WORKDIR /root/hg/pyogp.lib.client-maint/pyogp/lib/client
RUN patch -p0 </root/appearance.patch
RUN patch -p0 </root/login.patch
WORKDIR /root/hg/pyogp.lib.client-maint
RUN sed -i 's/self.inventory_host = self/#self.inventory_host = self/g' pyogp/lib/client/agent.py
RUN python setup.py install

RUN sed -i 's/\.aditi\./\.agni\./g' /root/hg/pyogp.apps/pyogp/apps/examples/*.py

ADD start.sh /root/hg/pyogp.apps/pyogp/apps/examples/start.sh
RUN chmod 755 /root/hg/pyogp.apps/pyogp/apps/examples/start.sh
RUN useradd -m pyogp

CMD ["/root/hg/pyogp.apps/pyogp/apps/examples/start.sh"]
