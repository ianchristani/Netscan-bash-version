#!/bin/bash

echo "===== Scan de rede NTSCB ======"
echo "IP e a faixa da rede:"
ip a
echo "Digite a faixa de IP:"
read faixaip

echo "Teste de ICMP:"
lista_ips=()
for ip in $faixaip.{1..254}; do
  ping -c 1 -W 1 $ip &>/dev/null && lista_ips+=("$ip") && echo "$ip está ativo"
done
echo "Total host up: ${#lista_ips[@]}"

echo "Teste de portas:"
for ip in "${lista_ips[@]}"; do
  echo "IP target: $ip"
  nc -zvw1 $ip 1-1023 2>&1 | grep -i succeeded
done
echo "===== FIM ======"
