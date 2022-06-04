# This Docker file follows the guide on https://github.com/liqd/adhocracy-plus/blob/main/docs/installation_prod.md
ARG VERSION_UBUNTU=22.04
FROM ubuntu:${VERSION_UBUNTU} as base

# Define build args
ARG VERSION_ADHOCRACY='v2202.2'
ARG NODE_OPTIONS='--openssl-legacy-provider'
ARG APLUS_HOME=/home/aplus

# Define environment variables
ENV APLUS_HOME=${APLUS_HOME}
ENV PATH="${APLUS_HOME}/.local/bin:${PATH}"

# Use bash for the whole build process
SHELL ["/bin/bash", "-c"]

##############
# Prepare OS #
##############

# Install required OS packages
RUN apt-get update && apt-get install -y python3 python3-pip gettext git curl libmagic1

# Add NodeSource as new package source and install a current nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update && apt-get install -y nodejs && node --version && npm --version

# Create user to run adhocracyplus
RUN useradd -ms /bin/bash aplus
USER aplus

# Created needed paths
RUN mkdir -p ${APLUS_HOME}/aplus-media ${APLUS_HOME}/app

# Set workdir to newly created home
WORKDIR ${APLUS_HOME}

###############
# Install app #
###############

# Get the code, install dependencies and build
RUN git clone https://github.com/liqd/adhocracy-plus.git app \
    && cd app \
    && git checkout tags/$VERSION_ADHOCRACY -b $VERSION_ADHOCRACY

# Set workdir to newly created app dir
WORKDIR ${APLUS_HOME}/app

# Apply patch to package.json to fix broken dependencies
COPY patches ${APLUS_HOME}/patches
RUN git apply ${APLUS_HOME}/patches/v2022.02_node_dependencies.patch

# Install NPM dependencies and build
RUN npm install --verbose && npm run build:prod
RUN pip install -r requirements.txt \
    && python3 manage.py compilemessages \
    && python3 manage.py collectstatic


#################
# Configure app #
#################
FROM base

# Define build args
ARG CONFIG_PATH_HOST=./configs/dockerized.py
ARG CONFIG_PATH_CONTAINER=${APLUS_HOME}/app/adhocracy-plus/config/settings/local.py
ARG DJANGO_SETTINGS_MODULE=adhocracy-plus.config.settings.local

# Define environment variables
ENV DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE}

COPY ${CONFIG_PATH_HOST} ${CONFIG_PATH_CONTAINER}
RUN python3 manage.py migrate

###########
# RUN app #
###########

EXPOSE 8000
ENTRYPOINT ["python3", "manage.py", "runserver", "0.0.0.0:8000"]