com pasta vars vazia (sem rede):

copiar chaincode para dentro de vars, de modo que fique vars/chaincode
./minifab up -e 7100 -o org0.com -l go -s couchdb -c channel0 -n fleetwatch -v 0.0.1 -p '' -d false
./minifab explorerup -e 7100

se erro "Error: proposal failed with status: 500 - failed to invoke backing implementation of 'CommitChaincodeDefinition': chaincode definition not agreed to by this org (org0-com)" durante "cc commit"
./minifab commit,initialize

com rede previamente levantada

./minifab netup,profilegen,discover -e 7100

pra levantar outros chaincodes

./minifab ccup -l go -n <nome_do_chaincode> -v <versao_do_chaincode> -d false