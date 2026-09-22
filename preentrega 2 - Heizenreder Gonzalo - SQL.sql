create database retail_project;

--DDL
drop table if exists clientes cascade;

create table clientes(
	id_cliente serial primary key,
	nombre_cliente varchar(50) not null,
	email_cliente varchar(50) not null unique
);

drop table if exists productos cascade;

create table productos(
	id_producto serial primary key,
	nombre_producto varchar(50) not null,
	categoria varchar(50) not null,
	precio_producto decimal(10,2) not null,
	constraint chk_precio_positivo check(precio_producto > 0),
	stock_producto int not null,
	constraint chk_stock_positivo check(stock_producto >= 0)
);

drop table if exists ventas cascade;

create table ventas(
	id_ventas serial primary key,
	id_cliente int references clientes(id_cliente),
	id_producto int references productos(id_producto),
	cantidad int not null,
	constraint chk_venta_positivo check(cantidad > 0),
	monto decimal(10,2) not null,
	constraint chk_monto_positivo check(monto > 0)
);


--DML
begin;

insert into clientes(nombre_cliente, email_cliente) values
	('Gonzalo Frutos', 'gonzalofrutos@emailfalso.com'),
	('Isaias Martinez', 'isaiasmartinez@emailfalso.com'),
	('Micaela Medina', 'micaelamedina@emailfalso.com'),
	('Silvia Romero', 'silviaromero@emailfalso.com'),
	('Lautaro Lopez', 'lautarolopez@emailfalso.com');

insert into  productos(nombre_producto, categoria, precio_producto, stock_producto) values 
	('Camisa', 'Vestimenta', 31000, 15),
	('Jean', 'Vestimenta', 35500, 20),
	('Campera', 'Vestimenta', 28000, 17),
	('Zapatillas', 'Vestimenta', 25700, 10),
	('Borcegos', 'Vestimenta', 44200, 7);

insert into ventas(id_cliente, id_producto, cantidad, monto) values
	(1, 3, 1, 28000),
	(2, 4, 1, 25700),
	(3, 5, 1, 44200),
	(4, 2, 1, 35500),
	(5, 1, 2, 62000);

commit;

--Uso de UPDATE
select id_producto, nombre_producto, precio_producto
from productos
where categoria = 'Vestimenta';

--Aumento del 10% en los productos de la categoría "Vestimenta"
update productos
set precio_producto = precio_producto  * 1.10
where categoria = 'Vestimenta';

--Uso de DELETE
select id_ventas, id_cliente, id_producto, monto
from ventas
where id_ventas = 4;

delete from ventas 
where id_ventas = 4;

