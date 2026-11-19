#!/usr/bin/env bash
# Diagnóstico inicial del VPS — solo lectura. No modifica nada.
s() { echo; echo "=== $1 ==="; }

s SISTEMA;   lsb_release -ds; uname -r; uptime -p; whoami; id -nG
s RECURSOS;  nproc; free -h; df -h / | tail -1
s REINICIO;  [ -f /var/run/reboot-required ] && cat /var/run/reboot-required.pkgs 2>/dev/null | head -20 || echo "no requerido"
s PUERTOS;   ss -tuln | awk 'NR>1{print $1,$5}' | sort -u
s NGINX;     nginx -v 2>&1; ls -la /etc/nginx/sites-enabled/ 2>&1
             grep -hE "^\s*(server_name|listen|root|proxy_pass)" /etc/nginx/sites-enabled/* 2>/dev/null | sed 's/^\s*//' | sort | uniq -c
s PM2_PROCESOS; ps -eo user,pid,%mem,rss,cmd --sort=-rss | grep -Ei "pm2|node|python|uvicorn|gunicorn" | grep -v grep | head -20
s TOP_MEMORIA;  ps -eo user,%mem,rss,comm --sort=-rss | head -12
s RUNTIMES;  for c in node npm python3 git docker psql pm2 certbot ufw; do printf "%-8s " $c; command -v $c >/dev/null && ($c --version 2>&1 | head -1) || echo "no instalado"; done
s SERVICIOS; systemctl is-active nginx docker postgresql 2>&1 | paste -sd' '; systemctl list-units --type=service --state=running --no-pager --no-legend | awk '{print $1}' | head -40
s SSL;       ls /etc/letsencrypt/live/ 2>&1
s FIREWALL;  systemctl is-active ufw 2>&1; ls /etc/ufw/user.rules >/dev/null 2>&1 && grep -E "^### tuple" /etc/ufw/user.rules 2>/dev/null
s SSHD;      grep -hE "^\s*(PasswordAuthentication|PermitRootLogin|Port|PubkeyAuthentication)" /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf 2>/dev/null
s ACTUALIZACIONES; apt list --upgradable 2>/dev/null | grep -c upgradable
s DNS;       for h in desafiocircular.org www.desafiocircular.org preview.desafiocircular.org betosalinas.cl; do printf "%-30s " $h; getent ahostsv4 $h | awk '{print $1}' | sort -u | paste -sd' '; done
s RUNNER;    systemctl list-units --no-pager --no-legend 'actions.runner*' 2>&1
s SRV;       ls -la /srv /srv/desafiocircular 2>&1
