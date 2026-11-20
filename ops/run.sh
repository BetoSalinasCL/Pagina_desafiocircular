#!/usr/bin/env bash
curl -sL -o /dev/null -w "betosalinas.cl final: %{http_code} %{url_effective}\n" https://betosalinas.cl/
curl -s -o /dev/null -w "preview.betosalinas.cl: %{http_code}\n" https://preview.betosalinas.cl/
