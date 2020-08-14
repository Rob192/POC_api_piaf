FROM python:3.6-slim as base

RUN apt-get update -qq \
 && apt-get install -y --no-install-recommends \
    # required by psycopg2 at build and runtime
    libpq-dev \
     # required for health check
    curl \
 && apt-get autoremove -y

FROM base as builder

RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  build-essential \
  wget \
  openssh-client \
  graphviz-dev \
  pkg-config \
  git-core \
  openssl \
  libssl-dev \
  libffi6 \
  libffi-dev \
  libpng-dev

COPY requirements.txt app/requirements.txt

# change working directory
WORKDIR /app

# install dependencies
RUN python -m venv env && \
    pip install -r requirements.txt

# make sure we use the virtualenv
ENV PATH="/env/bin:$PATH"

# spacy link
RUN python -m spacy download en_core_web_md && \
    python -m spacy link en_core_web_md en

# spacy link fr
RUN python -m spacy download fr_core_news_sm && \
    python -m spacy link fr_core_news_sm fr

# start a new build stage
FROM builder

WORKDIR /app

# copy everything from /env
#COPY --from=builder app/env /env

# make sure we use the virtualenv
ENV PATH="/env/bin:$PATH"


# copy files
COPY . .

# update permissions & change user to not run as root
RUN chgrp -R 0 /app && chmod -R g=u /app
USER 1001

# Create a volume for temporary data
VOLUME /tmp

## change shell
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN rasa train

# the entry point
EXPOSE 5005
ENTRYPOINT ["rasa"]
CMD ["--help"]