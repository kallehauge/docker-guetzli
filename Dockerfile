# Build stage
FROM alpine:3.19 AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    git \
    libpng-dev \
    make \
    linux-headers

# Clone and build Guetzli
WORKDIR /build
RUN LATEST_COMMIT=$(git ls-remote --sort=-v:refname https://github.com/google/guetzli.git HEAD | head -n1 | cut -f1) \
    && echo "Using Guetzli commit: $LATEST_COMMIT" \
    && git clone --depth 1 https://github.com/google/guetzli.git . \
    && make

# Final stage
FROM alpine:3.19

# Install only runtime dependencies
RUN apk add --no-cache \
    libpng \
    libstdc++

# Copy only the necessary files from builder
COPY --from=builder /build/bin/Release/guetzli /opt/guetzli/bin/

# Add Guetzli bin directory to PATH
ENV PATH="/opt/guetzli/bin:${PATH}"

# Create a working directory for images
WORKDIR /images

# Set the entrypoint to guetzli
ENTRYPOINT ["guetzli"]
