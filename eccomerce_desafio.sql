use eccomerce_desafio;

-- table implementada
 create table payments(
	idClientP int,
    id_payment int,
    id_productP int,
    typePayment enum('Boleto', 'Cartão Crédito', 'Cartão Débito', 'Cartão crédito parcelado', 'Pix') default 'Cartão Crédito',
    primary key(idClientP, id_payment, id_productP),
    constraint fk_pay_order foreign key (id_payment) references orders(idOrder),
    constraint fk_pay_idClient foreign key (idClientP) references clients(idClient),
    constraint fk_pay_prod foreign key (id_productP) references product(idProduct)
 );
 
 -- criação das outras tabelas, as mesmas repassadas no database eccomerce
  create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(60),
    constraint unique_cpf_client unique (CPF)
 );
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(20),
    classification_kids bool default false,
    category enum('Eletrônico', 'Vestimenta','Brinquedos','Alimentos','Móveis') not null,
    avaliação float default 0,
    size varchar(10)
 );
create table orders (
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false,
	foreign key (idOrderClient) references clients(idClient)
);
create table productStorage (
	idprodStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantityy int default 0
);
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product (idProduct)
);
create table supplier (
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact varchar(11) not null,
    constraint unique_supplier unique (CNPJ)
);
create table seller (
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15),
    AbstName varchar(255),
    CPF char(15),
    location varchar(255),
    contact varchar(11) not null,
    constraint unique_supplier unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references seller(idPOproduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);
create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

-- Queries

-- Relaciona os id de pagamento dos produtos da table payments e
-- a id da idClientP da table product
select concat(c.Fname, ' ', c.Lname) as Client_name, pa.id_payment, 
pa.idClientP, pa.id_productP from payments as pa
inner join clients as c 
where pa.id_payment = c.idClient;

-- relaciona nome completo de clientes da tabela clients, com o id_payments
-- e suas respectivas formas de pagamento, sincronizado apenas com clientes 
-- que realizaram algum pedido

select concat(c.Fname, ' ', c.Lname) as Client_name, 
concat('00', pa.id_payment) as id_pay, p.Pname as Product, pa.typePayment
from clients c join payments pa on c.idClient = idClientP
join product p on pa.id_productP = p.idProduct
order by pa.id_payment;

-- relaciona nome completo de clientes da tabela clients, com o id_payments
-- e suas respectivas formas de pagamento, sincronizado apenas com clientes 
-- que realizaram algum pedido, mostra a quantidade de produtos pedidos, junto com
-- o valor individual, e a culumn final multiplicando pela quantidade de pedidos em reais

select concat(c.Fname, ' ', c.Lname) as Client_name, 
concat('00', pa.id_payment) as id_pay, p.Pname as Product, 
pa.typePayment, o.quantityProdOrder as quantity_pruduct , concat('R$ ',o.sendValue) send_value, 
concat('R$ ', round(o.sendValue * quantityProdOrder, 2)) as Final_value
from clients c join payments pa on c.idClient = idClientP
join product p on pa.id_productP = p.idProduct
join orders o on o.idOrder = idClientP
order by pa.id_payment;

	
-- persistência de dados, baseados no modelo de eccomerce que foi proposto
insert into payments (idClientP, id_payment, id_productP, typePayment) values
					  (1,1,2,'Boleto'),
                      (2,2,5,'Cartão Débito'),
                      (3,3,3,'Pix'),
                      (4,4,1,'Cartão Crédito'),
                      (5,5,3,'Boleto');

 insert into clients (Fname, Minit, Lname, CPF, Address) values
					        ('Joana','S','Machado', 124536987,'rua do tijuca 110, Costa e silva - Porto de Galinhas'),
							('Gilberta','T','Nunes', 012457895,'rua guanabara 70, centro - Porto de Galinhas'),
                            ('Ricardo','F','Silva', 45678913,'avenida almeida 249, Centro - Cidade das flores'),
                            ('Patrícia','S','França', 789123456,'rua laranjeiras 821, Centro - Cidade das flores'),
                            ('Roberta','G','Assis', 98745631,'avenida koller 11, Centro - Cidade das flores'),
                            ('Amaral','M','Cruz', 654789123,'rua almeida das flores 21, Centro - Cidade das flores');

 insert into product (Pname, classification_kids, category, avaliação, size) values
					 ('Fone de ouvido',false,'Eletrônico','4',null),
                     ('Barbie Elsa',true,'Brinquedos','3',null),
                     ('Body Carters',true,'Vestimenta','5',null),
                     ('Microfon Vedo',false,'Eletrônico','4',null),
                     ('Fone de ouvido',false,'Móveis','3','3x57x80');
                     
insert into orders(idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
				  (1, default, 'compra via aplicativo', null,1),
                  (2, default,'compra via aplicativo', 50,0),
                  (3, 'Confirmado', null, null, 1),
                  (4, default, 'compra via web site', 150,0);
                  
insert into productStorage (storageLocation, quantityy) values
						   ('Rio de janeiro',1000),
                           ('Rio de janeiro', 500),
                           ('São Paulo', 10),
                           ('São Paulo', 100),
                           ('São Paulo', 10),
                           ('Brasília', 60);
                           
insert into productsupplier (idPsSupplier, idPsProduct, quantity) values
							(1,1,500),
                            (1,2,400),
                            (2,4,633),
                            (3,3,5),
                            (2,5,10);
                      
insert into supplier (SocialName, CNPJ, contact) values
					 ('Almeida e filhos',123456789123456,'21985474'),
                     ('Eletrônicos Silva',854519649143457,'21985484'),
                     ('Eletrõnicos Valma', 934567893934695, '21975474');
                     
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
				   ('Tech eletronics',null,123456789456321,null,'Rio de Janeiro',219946287),
                   ('Botique Durgas', null, null, 123456783, 'Rio de Janeiro', 219567895),
                   ('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);
                   
insert into productSeller (idPseller, idPproduct, prodQuantity) values
						  (1,6,80),
                          (2,7,10);
                          
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
						 (1,1,2,null),
                         (2,1,1,null),
                         (3,2,1,null);
                         
insert into storagelocation (idLproduct, idLstorage, location) values
							(1,2,'RJ'),
                            (2,6,'GO');

