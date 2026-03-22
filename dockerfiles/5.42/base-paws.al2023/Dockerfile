# Base Image for Lambda
# You add your function code and dependencies to the base image and
# then run it as a container image on AWS Lambda.

# the amazon/aws-lambda-provided:al2023 image doesn't have unzip,
# so we use the amazonlinux:2023 image here
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf install -y unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-runtime-al2023-x86_64/9eaec414f9a69fbe0474450440f8320e25b26f1d060efde679575ef0d6cc3f99.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-runtime-al2023-arm64/7a13cc4d35abe7c341103a0aa21182583685b7050c529c264707df467399a9fc.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf install -y unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-paws-al2023-x86_64/0940e938bd46a68804e4ea85b86de3e96b10e83334fe911560976dfc91a12369.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-paws-al2023-arm64/41c09ee7bc7334b4fdccadfcef23d13e7736090bfc432bd29a4f16f2ea086dec.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM public.ecr.aws/lambda/provided:al2023.2026.03.12.12

# Use the custom runtime perl in preference to the system perl
ENV PATH=/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY --from=0 /opt /opt
RUN ln -s /opt/bootstrap /var/runtime/bootstrap
COPY --from=1 /opt /opt
