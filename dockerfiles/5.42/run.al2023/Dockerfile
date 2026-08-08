# the provided.al2023 image doesn't have unzip,
# so we use the build-provided.al2023 image here
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf install -y unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-runtime-al2023-x86_64/8522e32e5bbced6cc05b641c4c5e2933479bd53cc23f7bb315c4c80d4d71b856.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-42-runtime-al2023-arm64/e3c0d9fca36c0524786e24b03609bcc53be529715207264efab0e79b96c8e983.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM ghcr.io/shogo82148/lambda-provided:al2023.2026.08.07
COPY --from=0 /opt /opt
