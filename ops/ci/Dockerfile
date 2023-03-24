ARG RUBY_VERSION
ARG DISTRO_NAME=bullseye

FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME

ARG DISTRO_NAME

# Common dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=tmpfs,target=/var/log \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      build-essential \
      gnupg2 \
      curl \
      less \
      git  \
      openssh-client

# Install PostgreSQL dependencies like libpq-dev and postgresql-client
ARG PG_MAJOR
ARG PG_VERSION
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=tmpfs,target=/var/log \
    apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      libpq-dev \
      postgresql-client-$PG_VERSION



ENV FILEBEAT_VERSION=8.3.3
# adapted from https://hub.docker.com/r/eason02/filebeat-alpine/dockerfile/
RUN curl https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -o /filebeat.tar.gz && \
  tar xzvf filebeat.tar.gz && \
  rm filebeat.tar.gz && \
  mv filebeat-${FILEBEAT_VERSION}-linux-x86_64 filebeat && \
  cd filebeat && \
  cp filebeat /usr/bin/

ARG NODE_MAJOR
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=tmpfs,target=/var/log \
    curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      nodejs


# Application dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=tmpfs,target=/var/log \
    --mount=type=bind,source=ops/AppDependencies,target=/tmp/AppDependencies \
    apt-get update -qq &&     DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      $(grep -Ev '^\s*#' /tmp/AppDependencies | xargs)


# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLER_VERSION=2.3.26

# Store Bundler settings in the project's root
ENV BUNDLE_APP_CONFIG=.bundle

# Uncomment this line if you want to run binstubs without prefixing with `bin/` or `bundle exec`
ENV PATH /app/bin:$PATH

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system  && \
  gem install bundler -v 2.3.26

# Create a directory for the app code
RUN mkdir -p /app
WORKDIR /app

# Document that we're going to expose port 3000
EXPOSE 3000

COPY Gemfile Gemfile.lock /app/


# bundle install
RUN \
  --mount=type=ssh \
  --mount=type=secret,id=vendor_api_access \
--mount=type=secret,id=secure_request_salt \
  mkdir -p /root/.ssh \
  && ssh-keyscan github.com >> /root/.ssh/known_hosts \
  && VENDOR_API_ACCESS=$(cat /run/secrets/vendor_api_access) SECURE_REQUEST_SALT=$(cat /run/secrets/secure_request_salt) bundle install

# Install JavaScript libraries
ADD package.json package-lock.json /app/
RUN npm install


COPY . /app/

RUN mkdir -p tmp/cache log

ARG GIT_HASH
ARG GIT_BRANCH
ENV GIT_HASH=$GIT_HASH
ENV GIT_BRANCH=$GIT_BRANCH
