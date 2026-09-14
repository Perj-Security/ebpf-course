#!/bin/sh
set -e

if [ ! -f /sys/kernel/tracing/available_events ]; then
  mount -t tracefs tracefs /sys/kernel/tracing || true
fi

test -r /sys/kernel/tracing/available_events || {
    echo "tracefs is unavailable; bpftrace cannot run"
    exit 1
}

# Start bpftrace in background if config exists
if [ -f /etc/bpftrace/bpftrace.config ]; then
  bpftrace /etc/bpftrace/bpftrace.config > /var/log/bpftrace.log 2>&1 &
fi

# Execute the container's main command
exec "$@"
