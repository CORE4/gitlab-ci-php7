FROM debian:jessie

# The nodejs version from debian is outdated
RUN apt-get update -y && apt-get install -y curl locales
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

COPY config/blacklist_php5 /etc/apt/preferences.d/blacklist_php5
COPY config/dotdeb.list /etc/apt/sources.list.d/dotdeb.list
COPY config/dotdeb.gpg /tmp/dotdeb.gpg
RUN apt-key add /tmp/dotdeb.gpg

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
    nodejs \
    ruby \
    ruby-dev \
    libmysqlclient-dev \
    cmake \
    pkg-config \
    imagemagick \
    git \
    php7.0-dev \
    php7.0-cli \
    php-pear \
    php7.0-mysql \
    php7.0-curl \
    php7.0-imagick \
    php7.0-zip \
    php7.0-mcrypt \
    php7.0-redis \
    php7.0-gd \
    php7.0-fpm \
    php7.0-intl \
    php7.0-mbstring \
    php7.0-xml \
    php7.0-sqlite3

COPY config/php7-cli.ini /etc/php/7.0/cli/php.ini

COPY config/prepare_environment /usr/local/bin/prepare_environment

RUN cd /usr/local/bin/ && curl https://getcomposer.org/installer | php && mv composer.phar composer

RUN gem install bundler
RUN bundle config --global silence_root_warning 1

# Use correct Port for git
RUN mkdir -p ~/.ssh && echo -e "\nHost git.core4.de\n\tPort 22225" >> ~/.ssh/config

# Preset some environment vars
ENV LC_ALL=en_US.UTF-8
    LANG=en_US.UTF-8
    COMPOSER_NO_INTERACTION=1
    COMPOSER_ALLOW_SUPERUSER=1
