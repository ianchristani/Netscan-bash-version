#!/bin/bash

echo "===== DNS scan ====="
echo "by |/\|\|"
echo "________________________________"
echo "Entre com o dominio a ser pesquisado"
read dominio
resultado_total=""
# importando as linhas uma por uma, nao em uma variavel
while IFS= read -r linha
do
    resultado=$(dig "$linha.$dominio" ANY)

    resultado_total+="$resultado\n"

done < subdomain.txt

echo -e "$resultado_total"
echo "===== FIM ======"




