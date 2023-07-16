-- criação do banco de dados para o cenário de eccomerce
create database eccomerce;
use eccomerce;
show tables;
 -- criar tabelas cliente
 create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(60),
    constraint unique_cpf_client unique (CPF)
 );
 alter table clients auto_increment=1;
 insert into clients (Fname, Minit, Lname, CPF, Address)
					  values('Joana','S','Machado', 124536987,'rua do tijuca 145, Costa e silva - Porto de Galinhas'),
							('Gilberta','T','Nunes', 012457895,'rua guanabara 75, centro - Porto de Galinhas'),
                            ('Ricardo','F','Silva', 45678913,'avenida almeida 289, Centro - Cidade das flores'),
                            ('Júlia','S','França', 789123456,'rua laranjeiras 861, Centro - Cidade das flores'),
                            ('Roberta','G','Assis', 98745631,'avenida koller 19, Centro - Cidade das flores'),
                            ('Isabela','M','Cruz', 654789123,'rua almeida das flores 28, Centro - Cidade das flores');
                            
  create table product(
	idProduct int auto_increment primary key,
    Pname varchar(20),
    classification_kids bool default false,
    category enum('Eletrônico', 'Vestimenta','Brinquedos','Alimentos','Móveis') not null,
    avaliação float default 0,
    size varchar(10)
 );

 insert into product (Pname, classification_kids, category, avaliação, size) values
					 ('Fone de ouvido',false,'Eletrônico','4',null),
                     ('Barbie Elsa',true,'Brinquedos','3',null),
                     ('Body Carters',true,'Vestimenta','5',null),
                     ('Microfon Vedo',false,'Eletrônico','4',null),
                     ('Fone de ouvido',false,'Móveis','3','3x57x80');

create table orders (
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    quantityProdOrder int not null,
	foreign key (idOrderClient) references clients(idClient)
);
drop table orders;
insert into orders(idOrderClient, orderStatus, orderDescription, sendValue, quantityProdOrder) values
				  (1, default, 'compra via aplicativo', 60.99,1),
                  (2, default,'compra via aplicativo', 52.95,2),
                  (3, 'Confirmado', null, 40.99, 3),
                  (4, default, 'compra via web site', 152.50,4),
                  (5, default, 'compra via aplicativo', 40.99,2);

create table productStorage (
	idprodStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantityy int default 0
);

insert into productStorage (storageLocation, quantityy) values
						   ('Rio de janeiro',1000),
                           ('Rio de janeiro', 500),
                           ('São Paulo', 10),
                           ('São Paulo', 100),
                           ('São Paulo', 10),
                           ('Brasília', 60);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product (idProduct)
);

insert into productsupplier (idPsSupplier, idPsProduct, quantity) values
							(1,1,500),
                            (1,2,400),
                            (2,4,633),
                            (3,3,5),
                            (2,5,10);
                            
create table supplier (
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact varchar(11) not null,
    constraint unique_supplier unique (CNPJ)
);
insert into supplier (SocialName, CNPJ, contact) values
					 ('Almeida e filhos',123456789123456,'21985474'),
                     ('Eletrônicos Silva',854519649143457,'21985484'),
                     ('Eletrõnicos Valma', 934567893934695, '21975474');

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

insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
				   ('Tech eletronics',null,123456789456321,null,'Rio de Janeiro',219946287),
                   ('Botique Durgas', null, null, 123456783, 'Rio de Janeiro', 219567895),
                   ('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);
insert into productSeller (idPseller, idPproduct, prodQuantity) values
						  (1,6,80),
                          (2,7,10);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references seller(idPOproduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
						 (1,1,2,default),
                         (2,1,1,default),
                         (3,2,1,default);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);
insert into storagelocation (idLproduct, idLstorage, location) values
							(1,2,'RJ'),
                            (2,6,'GO');