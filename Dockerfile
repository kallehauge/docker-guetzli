FROM alpine:3.19

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    git \
    libpng-dev \
    make \
    linux-headers

# Clone and build Guetzli
RUN git clone https://github.com/google/guetzli.git /guetzli \
    && cd /guetzli \
    && make \
    && mv bin/Release/guetzli /usr/local/bin/ \
    && cd / \
    && rm -rf /guetzli

# Create a working directory for images
WORKDIR /images

ENTRYPOINT ["guetzli"]