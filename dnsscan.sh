#!/bin/bash

echo "===== DNS scan ====="
echo "by |/\|\|"
echo "________________________________"
echo "Enter the domain to be searched:"
read dominio

echo "Enter the subdomain source file (.txt) path to be used:"
read subdomain_file

# importando as linhas uma por uma, nao em uma variavel
while IFS= read -r linha
do
    resultado=$(dig +short +time=2 +tries=1 "$linha.$dominio" A)
    if [ -n "$resultado" ]; then
        echo "$linha.$dominio -> $resultado"
    fi

done < "$subdomain_file"

echo "===== END ======"