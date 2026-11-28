# the provided.al2023 image doesn't have unzip,
# so we use the build-provided.al2023 image here
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN dnf install -y unzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-44-runtime-al2023-x86_64/8e11226bc076881b7c9a298d0ba8b3a052c23687e765e6e421c84924fe655258.zip
ENV ARCHIVE_URL_ARM64=https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-44-runtime-al2023-arm64/2a7037ede00623736f4214044e341d4b56dcc8158da532e15ad8662f35f3a4f4.zip

ARG TARGETARCH
RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" -o runtime.zip && \
    unzip -o runtime.zip && rm runtime.zip


FROM ghcr.io/shogo82148/lambda-provided:al2023.2026.11.20
COPY --from=0 /opt /opt
