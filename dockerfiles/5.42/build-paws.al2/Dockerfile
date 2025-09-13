# the provided.al2 image doesn't have curl and unzip,
# so we use the public.ecr.aws/amazonlinux/amazonlinux:2 image here
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum install -y curl unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-runtime-al2-x86_64/5b72d5b8faeef47cafa9fc0f3df96354d8dfb2fc3d24b31c642eceeb681fb01b.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-runtime-al2-arm64/1f0d62edf6c86e225c4593d9b9ece50036ab47e4c447635d8345a92ba6ff64a5.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum install -y curl unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-paws-al2-x86_64/e0aefdff334aa630cb7aada959a42dc15cd5618af6ba95182e4298b8147cf1d9.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-paws-al2-arm64/4532a6fabc5d0b26cee849673f0ed201280b1b01b6831bcd58c21ac685ff3294.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM ghcr.io/shogo82148/lambda-provided:build-al2.2025.08.29

# Use the custom runtime perl in preference to the system perl
ENV PATH=/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# workaround for "xlocale.h: No such file or directory"
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    # build-provided.al2 lacks some development packages
    yum install -y expat-devel openssl openssl-devel && yum clean all

COPY --from=0 /opt /opt
COPY --from=1 /opt /opt
