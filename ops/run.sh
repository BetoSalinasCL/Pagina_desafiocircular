#!/usr/bin/env bash
for ns in ns1.sociovirtual.com 8.8.8.8; do echo "== @$ns"; dig +short desafiocircular.org TXT @$ns | grep spf; dig +short _dmarc.desafiocircular.org TXT @$ns; done
