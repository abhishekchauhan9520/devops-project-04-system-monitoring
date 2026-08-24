# Project 04 — Basic Linux System Monitoring

A small, practical DevOps project that collects core Linux system metrics and can schedule collection through `systemd`.

## What it demonstrates

- Bash scripting with strict error handling
- Linux `/proc` and `df` metric collection
- CPU load, memory and disk monitoring
- Configurable sampling interval and sample count
- File output for collected metrics
- `systemd` service + timer scheduling
- ShellCheck and automated smoke testing with GitHub Actions

## Run locally

```bash
./scripts/collect_metrics.sh
./scripts/collect_metrics.sh -i 5 -c 12
./scripts/collect_metrics.sh -o ./output/metrics.log
```

## Test

```bash
./tests/test_collect_metrics.sh
```

## Systemd

See [`docs/USAGE.md`](docs/USAGE.md) for installation and timer setup.

## Scope

This is intentionally a lightweight monitoring foundation rather than a replacement for Prometheus, Node Exporter, Nagios, or a full observability stack.
