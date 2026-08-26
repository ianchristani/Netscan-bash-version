#!/bin/bash

echo "===== Scan interno de rede ======"
echo "by |/\|\|"
echo "________________________________"

# pegando a interface de rede
interface=$(ip route show default | awk '{print $5}')
# pegando o meu IP + mascara de rede
ip_cidr=$(ip -o -4 addr show $interface | awk '{print $4}')
# Pegando o IP sem a mascara de rede
ip_addr=${ip_cidr%/*}
# mascara de rede
mascara=${ip_cidr#*/}
# delimitador para pegar o IP da rede
ipredefinder=$((mascara/8))
# pegando o IP da rede
ipdarede=$(echo $ip_addr | cut -d. -f1-$ipredefinder)

echo "***** Informacoes gerais *****"
echo "Interface em uso: $interface"
echo "Meu IP: $ip_addr"
echo "IP da rede: $ipdarede"
echo "CIDR: $mascara"
echo "________________________________"

echo "***** Teste de ICMP *****"

lista_ips=()

if [ "$ipredefinder" -eq 3 ]; then
  for ip in $ipdarede.{1..254}; do
    if [ $ip != $ip_addr ]; then
      ping -c 1 -W 1 $ip &>/dev/null && lista_ips+=("$ip") && echo "$ip está ativo"
    fi
  done

elif [ "$ipredefinder" -eq 2 ]; then
  for ip1 in $ipdarede.{1..254}; do
    for ip2 in $ip1.{1..254}; do
      if [ $ip2 != $ip_addr ]; then
        ping -c 1 -W 1 $ip2 &>/dev/null && lista_ips+=("$ip2") && echo "$ip2 está ativo"
      fi
    done
  done
else
  echo "Abortando... rede classe A não suportada"
fi


echo "Total host up: ${#lista_ips[@]}"

echo "***** Teste de portas *****"
for ip in "${lista_ips[@]}"; do
  echo "IP target: $ip"
  nc -zvw1 $ip 1-1023 2>&1 | grep -i succeeded
done
echo "===== FIM ======"
