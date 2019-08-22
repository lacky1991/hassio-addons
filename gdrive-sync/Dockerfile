ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

# Setup base
RUN apk add --no-cache \
    curl \
    unzip \
    inotify-tools \
    busybox \
    busybox-extras \
    sudo

# Copy data
COPY run.sh /
RUN ["chmod", "a+x", "/run.sh"]
WORKDIR /

CMD [ "/run.sh" ]
