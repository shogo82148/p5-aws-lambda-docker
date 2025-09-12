# Base Image for Lambda
# You add your function code and dependencies to the base image and
# then run it as a container image on AWS Lambda.

# the amazon/aws-lambda-provided:al2023 image doesn't have unzip,
# so we use the amazonlinux:2023 image here
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf install -y unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-38-runtime-al2023-x86_64/83741157846cbd7ee7e948cb0b3bb6c5fcb578c48a63ef4db396737277658dbb.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-38-runtime-al2023-arm64/4de97a104977811980f069ff6118a8679e82d2d4bdbee9bf287e484c48600449.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf install -y unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-38-paws-al2023-x86_64/1087a83113d7a80054f07f9161a57e5fcde441f83240041e964e2d9c36ee79d7.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-38-paws-al2023-arm64/f5a78419c85a784537f9b28673d8f1e540ce64f752b6159d1096741ddff9cf27.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM public.ecr.aws/lambda/provided:al2023.2025.09.12.04

# Use the custom runtime perl in preference to the system perl
ENV PATH=/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY --from=0 /opt /opt
RUN ln -s /opt/bootstrap /var/runtime/bootstrap
COPY --from=1 /opt /opt
