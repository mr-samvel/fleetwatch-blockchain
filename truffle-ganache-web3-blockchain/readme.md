Pra rodar:
ganache-cli
truffle migrate (em outro terminal pois o ganache-cli irá ficar ocupando o outro)
npm start

Ver no console dá página web que ele tá retornando um objeto com valores:
1, 1, 1, 1, 1, 1, 1, 1, 1, true

Caso der erro quanto ao networks, ir no arquivo json do build/contracts correspondente, ver qual número é e substituir no app.js

Aquele send lá tem que estar com o gas price estranho daquele jeito se não não funciona

Por enquanto só foi deploy do contrato Vehicles, tem que ver como faz pra deployar os contratos que necessitam do endereço do Vehicles no construtor

TODO: Adaptar a API em Express, modificar o gerador de diagnóstico pra incluir driver_id e fazer o frontend