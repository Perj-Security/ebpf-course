#!/bin/sh
set -e

if [ ! -f /sys/kernel/tracing/available_events ]; then
  mount -t tracefs tracefs /sys/kernel/tracing || true
fi

# Start bpftrace in background if config exists
if [ -f /etc/bpftrace/bpftrace.config ]; then
  bpftrace /etc/bpftrace/bpftrace.config > /var/log/bpftrace.log 2>&1 &
fi

# Execute the container's main command
exec "$@"
