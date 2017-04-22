FROM    ubuntu:16.04
RUN     apt-get update \
            && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            build-essential \
            libz-dev \
            git \
            ruby \
            ruby-bundler \
            ruby-dev \
            libmysqlclient20 \
            python \
            virtualenv \
            && apt-get clean
ADD     . /code
ENV     BASEPATH=/code
WORKDIR /code
RUN     bundle install
CMD     ["bundle", "exec", "rake", "spec"]
