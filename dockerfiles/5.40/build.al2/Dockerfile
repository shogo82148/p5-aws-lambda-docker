# the provided.al2 image doesn't have curl and unzip,
# so we use the build-provided.al2 image here
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum install -y curl unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-40-runtime-al2-x86_64/b54801d5bfc49e3f3d5f91e8c1a660564a5387ebe920739ec9103c16a2b95337.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-40-runtime-al2-arm64/bdb62335ab27edcac84a050b36529a3d0dec11798b00daa503ec6e78298163b0.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip

FROM ghcr.io/shogo82148/lambda-provided:build-al2.2025.02.15

# Use the custom runtime perl in preference to the system perl
ENV PATH=/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# workaround for "xlocale.h: No such file or directory"
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    # build-provided.al2 lacks some development packages
    yum install -y expat-devel openssl openssl-devel && yum clean all

COPY --from=0 /opt /opt
