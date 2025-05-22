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
2. Set up a build environment with all necessary dependencies
3. Clone the latest Guetzli commit (shallow clone)
4. Build Guetzli from source
5. Create a minimal runtime image containing only:
   - The compiled Guetzli binary
   - Required runtime libraries (libpng, libstdc++)
   - No build tools or dependencies

### Running the Local Build

After building the image, you can use it the same way as the Docker Hub version, just with the local image name:

```bash
# Compress a single image
docker run -v .:/images guetzli input.jpg output.jpg

# Compress with quality setting
docker run -v .:/images guetzli --quality 85 input.jpg output.jpg

# Process multiple images
for file in *.jpg; do
    docker run -v .:/images guetzli "$file" "compressed_$file"
done
```

### Image Details

The Docker image is optimized for both size and performance:

- Uses multi-stage build to minimize final image size
- Based on Alpine Linux for minimal base image size

Build stage optimizations:
- Minimal build dependencies:
  - build-base (gcc, make, etc.)
  - git (for cloning)
  - libpng-dev (for compilation)
  - linux-headers (for compilation)
- Efficient source acquisition:
  - Shallow git clone (--depth 1)
  - Latest commit only

Runtime stage optimizations:
- Minimal runtime dependencies:
  - libpng (for PNG support)
  - libstdc++ (required by the binary)
- Clean organization:
  - Guetzli installed to `/opt/guetzli/bin`
  - No build tools or dependencies included
  - No source code or git history included

## Troubleshooting

If you encounter any issues:

1. Ensure the input file exists and is readable
2. Check that you have write permissions in the output directory
3. Verify the Docker image was pulled/built successfully
4. Make sure you're using the correct file paths relative to your current directory
5. For custom builds, check the build logs for any compilation errors

## License

Guetzli is licensed under the Apache License 2.0. See the [Guetzli repository](https://github.com/google/guetzli) for details.
