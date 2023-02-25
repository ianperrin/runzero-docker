#
# Sample Containerfile for running the runZero Explorer in a container, with 
# screenshot support.
#
FROM debian:stable-slim

WORKDIR /opt/rumble

# Ensure curl is available and install tools for wireless scanning.
#
RUN apt update && apt install -y curl wireless-tools

# Install Chrome for screenshots.
#
RUN curl -o chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./chrome.deb

# Set AGENT_URL to be the download URL for your Linux runZero Explorer. To 
# find your URL, go to https://console.runzero.com/deploy/download/explorers 
# and click on the first URL box to copy it to the clipboard.
#
ENV AGENT_URL=https://console.runzero.com/download/explorer/DT[uniqueToken]/[versionID]/runzero-explorer-linux-amd64.bin

# This ID is used to track the Explorer even if the container is rebuilt.
# Set it to a unique 32 character hex ID. You can generate one via:
#
# $ openssl rand -hex 16
#
ENV RUMBLE_AGENT_HOST_ID=[UNIQUE-ID]

# If you need to set environment variables to change the Explorer behavior,
# you can do so via the ENV directive. Example:
#
# ENV RUMBLE_AGENT_LOG_DEBUG=true

ADD ${AGENT_URL} runzero-explorer.bin

RUN chmod +x runzero-explorer.bin

# For full functionality the runZero scanner needs to send and receive raw 
# packets, which requires elevated privileges. 
USER root

# The argument `manual` tells runZero not to look for SystemD or upstart.
ENTRYPOINT [ "/opt/rumble/runzero-explorer.bin", "manual" ]
