#!/bin/bash

# Hoje
DATE=$(date +%d)
CAMINHO_BKP=/vz/dump
NOME_BKP=$(cal | awk -v date="${DATE}" '{ for( i=1; i <= NF ; i++ ) if ($i==date) { print FNR-2 } }')
PORTASSH=22
USUARIOSSH=root
SVBACKUP=192.168.1.221

fazbackup() {
  [ -d "${CAMINHO_BKP}/${NOME_BKP}" ] || mkdir -p ${CAMINHO_BKP}/${NOME_BKP}
  echo "Iniciando dump da vm as `date`"
  /usr/bin/vzdump --exclude-path '.+/log/.+' --exclude-path '.+/bak/.+' --exclude-path '/tmp/.+' --exclude-path '/var/tmp/.+' --exclude-path '/var/run/.+pid' --snapshot --dumpdir=${CAMINHO_BKP}/${NOME_BKP} --compress --all
  echo "Completed dump at `date`"
  scp -P ${PORTASSH} ${CAMINHO_BKP}/${NOME_BKP} ${USUARIOSSH}@${SVBACKUP}:/backups
}

fazbackup

exit 0