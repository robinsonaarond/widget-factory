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
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
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
RUN gem update --system && \
  gem install bundler -v 2.3.26

# Create a directory for the app code
RUN mkdir -p /app
WORKDIR /app

# Document that we're going to expose port 3000
EXPOSE 3000

COPY Gemfile Gemfile.lock /app/

RUN \
    --mount=type=ssh \
    mkdir -p /root/.ssh \
    && ssh-keyscan github.com >> /root/.ssh/known_hosts \
    && bundle install


COPY . /app/

COPY config/secreq.example.yml config/secreq.yml
COPY config/vendor_api_data.example.yml config/vendor_api_data.yml

RUN mkdir -p tmp/cache log

ARG GIT_TAG
ENV GIT_TAG=${GIT_TAG}

CMD ops/bin/start-service.sh
