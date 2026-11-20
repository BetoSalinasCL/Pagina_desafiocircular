#!/usr/bin/env bash
for ns in ns1.sociovirtual.com 8.8.8.8 1.1.1.1; do printf "%-22s " $ns; dig +short preview.desafiocircular.org A @$ns | paste -sd' '; done
echo "== TXT/registros a migrar (muestra)"; dig +short desafiocircular.org TXT; dig +short _dmarc.desafiocircular.org TXT; dig +short google._domainkey.desafiocircular.org TXT | cut -c1-60
