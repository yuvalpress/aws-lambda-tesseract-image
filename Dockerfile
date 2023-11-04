# Stage 1: Build
FROM public.ecr.aws/lambda/python:3.9.2023.10.24.17 AS builder

# Install build tools and dependencies
RUN yum -y update && \
    yum -y install autoconf automake libtool && \
    yum -y install libpng-devel libjpeg-devel libtiff-devel zlib-devel && \
    yum -y install gcc gcc-c++ make && \
    yum -y install wget gzip glibc

# Build and install Leptonica
RUN wget http://www.leptonica.org/source/leptonica-1.80.0.tar.gz && \
    tar -xzf leptonica-1.80.0.tar.gz && \
    leptonica-1.80.0 && \
    chmod +x configure && \
    ./configure && \
    make && \
    make install

# Set leptonica in path
ENV PATH=/usr/sbin/:$PATH
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# Build and install Tesseract
RUN wget https://github.com/tesseract-ocr/tesseract/archive/4.1.1.tar.gz -O ./4.1.1.tar.gz && \
    tar -zxvf ./4.1.1.tar.gz && \
    cd tesseract-4.1.1 && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# Stage 2: Runtime
FROM public.ecr.aws/lambda/python:3.9.2023.10.24.17

# Copy compiled artifacts from builder stage
COPY --from=builder /usr/local/bin/tesseract /usr/local/bin/
COPY --from=builder /usr/local/lib/libtesseract.so.4 /usr/local/lib/liblept.so.5 /usr/local/lib/

RUN yum -y install \
    --setopt=install_weak_deps=False \
    --setopt=tsflags=nodocs \
    wget libjpeg libtiff libgomp

# Set Tesseract language files location
ENV TESSDATA_PREFIX=./tessdata

# Install languages for the pytesseract module
RUN mkdir -p ./tessdata && \
    wget https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata -O ./tessdata/eng.traineddata && \
    wget https://github.com/tesseract-ocr/tessdata/raw/main/heb.traineddata -O ./tessdata/heb.traineddata && \
    wget https://github.com/tesseract-ocr/tessdata/raw/main/ara.traineddata -O ./tessdata/ara.traineddata

