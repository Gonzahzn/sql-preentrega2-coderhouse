create database retail_project;

--DDL
drop table if exists clientes cascade;

create table clientes(
	id_cliente serial primary key,
	nombre_cliente varchar(50) not null,
	email_cliente varchar(50) not null unique
);

drop table if exists categorias cascade;

create table categorias(
	id_categoria serial primary key,
	nombre_categoria varchar(50) not null unique
);

drop table if exists productos cascade;

create table productos(
	id_producto serial primary key,
	nombre_producto varchar(50) not null,
	id_categoria int references categorias(id_categoria),
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
	constraint chk_monto_positivo check(monto > 0),
	fecha_venta DATE NOT NULL DEFAULT CURRENT_DATE
);


--DML
begin;

insert into categorias(nombre_categoria) values
	('Vestimenta'), ('Calzado'), ('Accesorios');
	
insert into clientes(nombre_cliente, email_cliente) values
	('Gonzalo Frutos', 'gonzalofrutos@emailfalso.com'),
	('Isaias Martinez', 'isaiasmartinez@emailfalso.com'),
	('Micaela Medina', 'micaelamedina@emailfalso.com'),
	('Silvia Romero', 'silviaromero@emailfalso.com'),
	('Lautaro Lopez', 'lautarolopez@emailfalso.com'),
	('Laura Rodriguez', 'laurarodriguez@emailfalso.com');

insert into  productos(nombre_producto, id_categoria, precio_producto, stock_producto) values 
	('Camisa', 1, 31000, 15),
	('Jean', 1, 35500, 20),
	('Zapatillas', 2, 25700, 10),
	('Borcegos', 2, 44200, 7),
	('Cinturon', 3, 12000, 30);

insert into ventas(id_cliente, id_producto, cantidad, monto) values
	(1, 3, 1, 25700),
	(2, 1, 2, 62000),
	(3, 5, 2, 24000),
	(4, 4, 1, 44200),
	(5, 2, 1, 35500);

commit;
rollback;


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


--Pre-entrega 4
--Consulta 1: Rentabilidad por categoría
--Sirve para detectar cuales son los productos que generan más ganancias, lo cual
--va a permitir saber en que vale la pena invertir más para vender.

--Umbral de ventas que definí: 30000
select 
	cat.nombre_categoria as categoria,
	sum(v.cantidad) as unidades_vendidas,
	sum(v.monto) as ingreso_total

from ventas v
join productos p on v.id_producto = p.id_producto
join categorias cat on p.id_categoria = cat.id_categoria

group by cat.nombre_categoria
having sum(v.monto) > 30000 
order by ingreso_total asc;


--Consulta 2: Clientes sin compra
--Puede servir para detectar aquellos clientes registrados que no están 
--realizando compra alguna
select 
	cl.id_cliente,
	cl.nombre_cliente,
	coalesce(count(v.id_ventas), 0) as compras_del_cliente
from clientes cl
left join ventas v on cl.id_cliente = v.id_cliente
where v.id_ventas is null
group by cl.id_cliente, cl.nombre_cliente;


--Consulta 3: Top de compras por cliente
--Sirve para detectar cuales son los productos más comprados en general entre los
--clientes registrados, así como tambien saber la fecha de última transacción para 
--tener en cuenta que se vendió en cierta temporada
select
	cl.nombre_cliente,
	p.nombre_producto as producto_mas_comprado,
	sum(v.cantidad)	as total_unidades,
	max(v.fecha_venta) as ultima_compra
from clientes cl
join ventas v on cl.id_cliente = v.id_cliente
join productos p on v.id_producto = p.id_producto
group by cl.nombre_cliente, p.nombre_producto
order by total_unidades desc
	