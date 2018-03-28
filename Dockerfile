# Install dependencies
FROM alpine:3.7 as builder
RUN apk update && apk upgrade
RUN apk add g++ musl musl-dev bash gawk gzip make tar gmp mpfr3 mpfr-dev mpc1 mpc1-dev isl isl-dev linux-headers binutils

# Switch to bash
RUN bash

# Download sources and extract
RUN wget ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz && tar -xvzf gcc-7.3.0.tar.gz

# Make directory for build
RUN mkdir build
WORKDIR build

# Configure
RUN /gcc-7.3.0/configure --enable-languages=c,c++ --disable-multilib --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --target=x86_64-alpine-linux-musl --disable-libsanitizer --disable-libatomic --disable-libitm

# Build
RUN make -j$(($(nproc --all) * 2))  BOOT_CFLAGS='-O3 -g0' profiledbootstrap

# Install stripped versions
RUN make install-strip

# Remove other packages, so that no files are unitentionally copied over
RUN apk del g++ musl musl-dev bash gawk gzip make tar gmp mpfr3 mpfr-dev mpc1 mpc1-dev isl isl-dev linux-headers binutils

# Final Stage
FROM alpine:3.7 as final

# Install runtime dependencies
RUN apk update && apk add musl libc-dev isl gmp binutils mpc1 mpfr3 musl-dev
# Copy required files from previous stage
COPY --from=builder /usr/local/bin /usr/bin
COPY --from=builder /usr/local/include /usr/include
COPY --from=builder /usr/local/lib /usr/lib
COPY --from=builder /usr/local/lib64 /usr/lib
COPY --from=builder /usr/local/libexec /usr/libexec
