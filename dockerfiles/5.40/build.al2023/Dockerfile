# the provided.al2023 image doesn't have unzip,
# so we use the build-provided.al2023 image here
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf install -y unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-40-runtime-al2023-x86_64/f114adf17300544e9bf75f28f7f0bd4e7db4261b7811c4f588a99f25035826ee.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-40-runtime-al2023-arm64/2a7074d7fad2cd2223fe4cdbf69650d095106f7abb51b3e10d5d7fac46e4e82b.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM public.ecr.aws/shogo82148/lambda-provided:build-al2023.2024.11.26

# Use the custom runtime perl in preference to the system perl
ENV PATH=/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# build-provided.al2023 lacks some development packages
RUN dnf install -y expat-devel openssl openssl-devel && dnf clean all

COPY --from=0 /opt /opt
