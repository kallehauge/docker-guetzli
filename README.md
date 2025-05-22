# Docker Guetzli

A Docker container for [Guetzli, Google's JPEG encoder](https://github.com/google/guetzli) that aims for excellent compression density at high visual quality.

## Features

- Uses Google's Guetzli JPEG encoder
- Based on Alpine Linux for minimal image size
- Optimized for both build time and runtime performance
- Supports both AMD64 (x86_64) and ARM64 architectures

### Notes

- Guetzli uses a large amount of memory (about 300MB per 1MPix of input image)
- Processing time is approximately 1 minute of CPU time per 1MPix of input image
- Input images should be in sRGB profile with a gamma of 2.2
- Guetzli will ignore any color-profile metadata in the image
- JPEG images do not support alpha channel (transparency). If the input is a PNG with an alpha channel, it will be overlaid on black background before encoding.

## Quick Start

Pull and use the image directly from Docker Hub:

```bash
# Pull the image
docker pull kallehauge/guetzli:latest

# Compress a JPEG image
docker run -v .:/images kallehauge/guetzli input.jpg output.jpg
```

### Common Usage Examples

Basic compression with quality setting:
```bash
docker run -v .:/images kallehauge/guetzli --quality 85 input.jpg output.jpg
```

Batch process all JPEGs in current directory:
```bash
for file in *.jpg; do
    docker run -v .:/images kallehauge/guetzli "$file" "compressed_$file"
done
```

### Available Options

Guetzli supports the following options:

- `--quality N`: Set quality to N (84-100, default 95)
- `--verbose`: Print a verbose trace of all attempts to the console
- `--memlimit N`: Memory limit in MB (default: 6000MB)

## For Developers

If you want to build the image yourself or contribute to the project:

### Prerequisites

- Docker installed on your system
- Basic understanding of Docker commands

### Building the Image

Build the Docker image using:

```bash
docker build -t guetzli .
```

This will:
1. Download the Alpine Linux base image
2. Install all necessary build dependencies
3. Clone and build Guetzli from source
4. Create a minimal runtime image with only required dependencies

### Image Details

The Docker image is optimized for both size and performance:

- Based on Alpine Linux for minimal image size
- Runtime dependencies are minimal:
  - `libpng-dev` for PNG support
- Build tools and dependencies are removed from the final image
- Package lists are cleaned up during build to reduce image size

## Troubleshooting

If you encounter any issues:

1. Ensure the input file exists and is readable
2. Check that you have write permissions in the output directory
3. Verify the Docker image was pulled/built successfully
4. Make sure you're using the correct file paths relative to your current directory
5. For custom builds, check the build logs for any compilation errors

## License

Guetzli is licensed under the Apache License 2.0. See the [Guetzli repository](https://github.com/google/guetzli) for details.
