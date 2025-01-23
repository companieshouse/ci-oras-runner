FROM amazonlinux:2023

# Set SHELL flags for RUN commands to allow -e and pipefail
# Rationale: https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

# Version arguments
ARG oras_version=1.2.2

# Update dnf
RUN dnf update -y && dnf upgrade -y

# Install aws and tar
RUN dnf install -y awscli-2 && \
    dnf install -y tar gzip

# Install oras
RUN curl -LO https://github.com/oras-project/oras/releases/download/v${oras_version}/oras_${oras_version}_linux_amd64.tar.gz && \
    curl -LO https://github.com/oras-project/oras/releases/download/v${oras_version}/oras_${oras_version}_checksums.txt && \
    grep "oras_${oras_version}_linux_amd64.tar.gz" oras_${oras_version}_checksums.txt | sha256sum -c - && \
    tar -xvzf oras_${oras_version}_linux_amd64.tar.gz oras && \
    mv oras /usr/local/bin/ && \
    rm oras_${oras_version}_linux_amd64.tar.gz oras_${oras_version}_checksums.txt

# Tidy up
RUN dnf remove -y tar gzip && \
    dnf clean all && \
    rm -rf /var/cache/dnf
