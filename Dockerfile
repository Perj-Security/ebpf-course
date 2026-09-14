FROM ubuntu:26.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        auditd \
        bpftrace \
        inotify-tools \
        less \
        linux-tools-common \
        linux-tools-generic \
        nano \
        tcpdump \
        nftables \
    && rm -rf /var/lib/apt/lists/*

# Copy auditd configurations
COPY filter.conf /etc/audit/plugins.d/
COPY audisp-filter.conf /etc/audit/
# Copy bpftrace configurations and select the architecture-specific one
COPY bpftrace.config bpftrace_arm64.config /etc/bpftrace/
RUN if [ "$(dpkg --print-architecture)" = "arm64" ]; then \
        echo "Detected ARM64 architecture, using bpftrace_arm64.config"; \
        cp /etc/bpftrace/bpftrace_arm64.config /etc/bpftrace/bpftrace.config; \
    else \
        echo "Using default bpftrace.config"; \
        cp /etc/bpftrace/bpftrace.config /etc/bpftrace/bpftrace.config; \
    fi

# Entrypoint will start bpftrace in background and then exec the container CMD
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["tail", "-f", "/dev/null"]