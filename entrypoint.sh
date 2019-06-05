#!/usr/bin/env bash
# Entry Point
# @author Vlad Ghinea

# Bash strict mode
set -euo pipefail
IFS=$'\n\t'

# VARs
LOGROTATE_DIRECTORIES="${LOGROTATE_DIRECTORIES:-/logs/*.log}"
LOGROTATE_INTERVAL="${LOGROTATE_INTERVAL:-daily}"
LOGROTATE_KEEP="${LOGROTATE_KEEP:-14}"
CRON_INTERVAL="${CRON_INTERVAL:-daily}"
TIME_ZONE="${TIME_ZONE:-}"
TIME_SERVER="${TIME_SERVER:-'pool.ntp.org'}"

generate_configuration(){
  echo '*** Generating configuration files'
  tee /etc/logrotate.d/docker <<END_LOGROTATE
${LOGROTATE_DIRECTORIES} {
  ${LOGROTATE_INTERVAL}
  rotate ${LOGROTATE_KEEP}
  compress
  delaycompress
  missingok
  notifempty
}
END_LOGROTATE
}

configure_timezone(){
  if [[ -n "${TIME_ZONE:-}" ]]; then
    cp "/usr/share/zoneinfo/${TIME_ZONE}" /etc/localtime
    echo "$TIME_ZONE" > /etc/timezone
  fi

  ntpd -q -p "$TIME_SERVER" || true
}

run_cron(){
  # The container will actually run as a cron daemon that will execute logrotate
  # on a schedule
  case ${CRON_INTERVAL} in
    hourly|daily|weekly|mothly)
      echo "*** Running ${CRON_INTERVAL}"
      ;;
    *)
      echo "*** The '${CRON_INTERVAL}' interval is not allowed"; exit 1
      ;;
  esac

  tee "/etc/periodic/${CRON_INTERVAL}/logrotate" >/dev/null <<END_CRONJOB
#!/bin/sh
/usr/sbin/logrotate /etc/logrotate.conf
END_CRONJOB

  chmod +x "/etc/periodic/${CRON_INTERVAL}/logrotate"

  exec crond -f -l 6
}

main(){
  # Make sure required files and directories exist
  touch /var/log/messages

  generate_configuration
  configure_timezone
  run_cron
}

main "${@:-}"
