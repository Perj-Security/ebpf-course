FROM ubuntu:latest

RUN apt-get update && apt-get install -y bpftrace inotify-tools && rm -rf /var/lib/apt/lists/*

# Copy bpftrace configuration
COPY bpftrace_arm64.config /etc/bpftrace/bpftrace.config

# Entrypoint will start bpftrace in background and then exec the container CMD
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["tail", "-f", "/dev/null"]