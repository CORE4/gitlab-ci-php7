FROM ruby:2.5-rc-stretch

# The nodejs version from debian is outdated
RUN apt-get update -y && apt-get install -y curl locales
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

COPY config/blacklist_php5 /etc/apt/preferences.d/blacklist_php5
COPY config/php71.list /etc/apt/sources.list.d/php71.list
COPY config/php71.gpg /tmp/php71.gpg
RUN apt-key add /tmp/php71.gpg

# Switch to Europe/Berlin
RUN ln --force --symbolic "/usr/share/zoneinfo/Europe/Berlin" "/etc/localtime"
RUN dpkg-reconfigure --frontend=noninteractive tzdata

# Switch to UTF-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN apt-get update -y && apt-get dist-upgrade -y && apt-get install -y \
    rsync \
    nodejs \
    default-libmysqlclient-dev \
    cmake \
    pkg-config \
    imagemagick \
    git \
    php7.1-dev \
    php7.1-cli \
    php-pear \
    php7.1-mysql \
    php7.1-curl \
    php7.1-imagick \
    php7.1-zip \
    php7.1-mcrypt \
    php7.1-redis \
    php7.1-gd \
    php7.1-fpm \
    php7.1-intl \
    php7.1-mbstring \
    php7.1-xml \
    php7.1-sqlite3 \
    php7.1-soap

# Necessary to fix the problem with package conflicts
RUN apt-get install -y libssl1.0-dev

RUN npm install -g yarn

COPY config/php7-cli.ini /etc/php/7.1/cli/php.ini

COPY config/prepare_environment /usr/local/bin/prepare_environment

RUN cd /usr/local/bin/ && curl https://getcomposer.org/installer | php && mv composer.phar composer

RUN gem install bundler
RUN bundle config --global silence_root_warning 1

# Use correct Port for git
RUN mkdir -p /root/.ssh
COPY config/ssh_config /root/.ssh/config

RUN date "+%s" > /build_date

# Preset some environment vars
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    COMPOSER_NO_INTERACTION=1 \
    COMPOSER_ALLOW_SUPERUSER=1
