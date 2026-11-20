#!/usr/bin/env bash
for t in NS SOA MX A; do echo "== $t"; dig +short desafiocircular.org $t; done
echo "== host IP actual"; dig +short -x 170.249.239.131
echo "== whois NS"; whois desafiocircular.org 2>/dev/null | grep -iE "name server|registrar:" | head
