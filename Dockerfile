FROM ubuntu:20.04

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
 && apt-get update -y \
 && apt-get install -y curl wget mysql-client openjdk-8-jdk gnupg gnupg2 gnupg1 \
 && apt-get install -y php7.4 php7.4-fpm php7.4-mbstring php7.4-xml php7.4-mysql php7.4-curl php7.4-cli \
 && apt-get install -y git unzip iputils-ping net-tools vim cron make sudo python3-pip npm \
 && apt-get install -y perl libperl-dev libgd3 libgd-dev libgeoip1 libgeoip-dev geoip-bin libxml2 libxml2-dev libxslt1.1 libxslt1-dev \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y tshark

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
 && php composer-setup.php --install-dir=/usr/bin --filename=composer

RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add - \
 && sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' \
 && apt-get update -y \
 && apt-get install jenkins -y 

RUN apt-get update -y \
 && apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y \
 && wget -q -O - https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
 && apt-get update -y \
 && apt-get install docker-ce docker-ce-cli containerd.io -y \
 && curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose \
 && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose \
 && /etc/init.d/docker start

RUN pip3 install mysql-connector

RUN npm install -g newman

RUN usermod -a -G sudo jenkins \
 && echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

CMD /bin/sh -c "/etc/init.d/jenkins start && tail -f /dev/null"
