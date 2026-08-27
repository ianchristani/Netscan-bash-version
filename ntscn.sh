#!/bin/bash

echo "===== Internal Net Scan ======"
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

echo "***** General Information *****"
echo "Interface in use: $interface"
echo "My IP: $ip_addr"
echo "Network IP: $ipdarede"
echo "CIDR: $mascara"
echo "________________________________"

echo "***** ICMP TEST *****"

lista_ips=()

if [ "$ipredefinder" -eq 3 ]; then
  for ip in $ipdarede.{1..254}; do
    if [ $ip != $ip_addr ]; then
      ping -c 1 -W 1 $ip &>/dev/null && lista_ips+=("$ip") && echo "$ip is up"
    fi
  done

elif [ "$ipredefinder" -eq 2 ]; then
  max_paralelo=50
 
  while IFS= read -r ip; do
      lista_ips+=("$ip")
      echo "$ip is up"
  done < <(
    for ip1 in {0..255}; do
      for ip2 in {1..254}; do
        ip="$ipdarede.$ip1.$ip2"
        if [ "$ip" != "$ip_addr" ]; then
          (ping -c 1 -W 1 "$ip" &>/dev/null && echo "$ip") &
          while (( $(jobs -rp | wc -l) >= max_paralelo )); do
              wait -n
          done
        fi
      done
    done
    wait
  )

else
  echo "Aborting... Class A network not supported"
fi

echo "Total host up: ${#lista_ips[@]}"
echo "***** Port Scan *****"

for ip in "${lista_ips[@]}"; do
  echo "IP target: $ip"
  nc -zvw1 $ip 1-1023 2>&1 | grep -i succeeded
done

echo "===== END ======"