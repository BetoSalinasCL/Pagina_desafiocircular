#!/usr/bin/env bash
for ns in ns1.sociovirtual.com 8.8.8.8; do echo "== @$ns"; dig +short google._domainkey.desafiocircular.org TXT @$ns | tr -d '" ' | head -c 90; echo; done
V=$(dig +short google._domainkey.desafiocircular.org TXT @ns1.sociovirtual.com | tr -d '" \n'); echo "largo clave p=: $(echo "$V" | sed 's/.*p=//' | wc -c)"
echo "$V" | grep -q '^v=DKIM1;k=rsa;p=MII' && echo "FORMATO OK" || echo "FORMATO REVISAR"
