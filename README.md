# Vlad's Logrotate

[![](https://images.microbadger.com/badges/image/vladgh/logrotate.svg)](https://microbadger.com/images/vladgh/logrotate "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/vladgh/logrotate.svg)](https://microbadger.com/images/vladgh/logrotate "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/vladgh/logrotate.svg)](https://microbadger.com/images/vladgh/logrotate "Get your own commit badge on microbadger.com")
[![](https://images.microbadger.com/badges/license/vladgh/logrotate.svg)](https://microbadger.com/images/vladgh/logrotate "Get your own license badge on microbadger.com")

Vlad's Logrotate Image

## Environment variables

- `LOGROTATE_DIRECTORIES`: Space separated list of directories (defaults to `/logs/*.log`)
- `LOGROTATE_INTERVAL`: rotate logfile according to the following intervals: `hourly`, `daily`, `weekly`, `monthly` (defaults to `daily`)
- `LOGROTATE_KEEP`: how many intervals to keep (defaults to `14`)
- `CRON_INTERVAL`: how often to run logrotate according to the following intervals: `hourly`, `daily`, `weekly`, `monthly` (defaults to `daily`)
- `TIME_ZONE`: sets the time zone (optional)
- `TIME_SERVER`: sets the NTP time server (optional)

## Usage

```
docker run -d \
  -v ./remote_logs:/logs
  vladgh/logrotate
```
