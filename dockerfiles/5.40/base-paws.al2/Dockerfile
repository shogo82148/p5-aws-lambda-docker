# Base Image for Lambda
# You add your function code and dependencies to the base image and
# then run it as a container image on AWS Lambda.

# the provided.al2 image doesn't have curl and unzip,
# so we use the public.ecr.aws/amazonlinux/amazonlinux:2 image here
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum install -y curl unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-40-runtime-al2-x86_64/2ee7b783501e09870c6a4283cf9b44595e0461d8279ccae5ee9cdd552affa7e0.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-40-runtime-al2-arm64/d8f7968edd816d0a54904b7f79d39fb9d865b0a8badc79c17e507b93e34a0a39.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum install -y curl unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-40-paws-al2-x86_64/9ebc942dd25b438504add55fb5ca76acaf96de9a71ba31e5212d7a17bfa279fa.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-40-paws-al2-arm64/6de74bf499c9f9702f7bcbb39ac0ddb28c481719bd488529da5245582178ab1b.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM public.ecr.aws/lambda/provided:al2.2025.05.01.12

# Use the custom runtime perl in preference to the system perl
ENV PATH=/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY --from=0 /opt /opt
RUN ln -s /opt/bootstrap /var/runtime/bootstrap
COPY --from=1 /opt /opt
