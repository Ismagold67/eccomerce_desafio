# DESAFIO ECCOMERCE 

De acordo com o desafio proposto, foram criados 2 instâncias sql,
uma mantendo os dados originais do banco de dados de eccomerce criado durante
a explicação do desafio, e a outra instância que é uma implementação desse 
banco de dados.

Foi criado uma tabela payments, que contem as variaveis que vão armazenar o
id do cliente que fez algum pedido, o id do pagamento, o id do produto que foi
feito algum pedido, sempre se relacionando com a table orders, e o tipo de pagamento, feito com um enum que pode ser 'Boleto', 'Cartão Crédito', 'Cartão Débito', 'Cartão crédito parcelado', 'Pix'.

Também foram implementadas algumas queries que faz a relação com a nova tabela criada apenas. As queries começam na linha 99. Foram queries com uma estrutura robusta, porém quis estrutura-las assim para se aprofundar mais no assunto.