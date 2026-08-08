# the provided.al2023 image doesn't have unzip,
# so we use the build-provided.al2023 image here
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf install -y unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-44-runtime-al2023-x86_64/3f9a8618dbab81f4a1978ed0a4292f876b77caf6cf6ece46bb038dadd3c6b9cc.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-44-runtime-al2023-arm64/f3fbbfaa3e910c4f8b57c1a36a8da80ceb908b3976f5327b5d976e6718f8de24.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM ghcr.io/shogo82148/lambda-provided:al2023.2026.08.07
COPY --from=0 /opt /opt
