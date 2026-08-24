# Usage

## Run once

```bash
./scripts/collect_metrics.sh
```

## Collect multiple samples

```bash
./scripts/collect_metrics.sh -i 5 -c 12
```

## Write to a file

```bash
./scripts/collect_metrics.sh -o ./output/metrics.log
```

The script reports UTC timestamp, 1-minute load average, memory usage percentage, and root filesystem usage percentage.

## Install the systemd timer

Copy the script to `/usr/local/bin/collect_metrics.sh`, copy the service and timer to `/etc/systemd/system/`, create `/var/log/system-monitor`, then run:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now monitor.timer
systemctl list-timers monitor.timer
```

The service writes metrics to `/var/log/system-monitor/metrics.log`.
