# SQLProjects


### Following are two tables. Use them to answer these 3 questions:
1. Select 2nd costliest order for cust_id 1004 from customer table
2. Select all cust_id and their costliest orders from customer table
3. select the costliest order for all customers with their names and city

### SQL Code

#### Create Tables:
```
create table orders(
id int,
cust_id int,
price int,
created_at varchar(255)
)

INSERT INTO orders (id, cust_id, price, created_at)
VALUES (1 ,1001 ,1000 ,'20200710_135351'),
(2 ,1002 ,800 ,'20200710_135358'),
(3 ,1003 ,2000 ,'20200710_135404'),
(4 ,1002 ,900 ,'20200710_135410'),
(5 ,1004 ,900 ,'20200711_135414'),
(6 ,1004 ,1000 ,'20200711_135421'),
(7 ,1004 ,500 ,'20200711_135421'),
(8 ,1003 ,3000 ,'20200711_135450')


create table customer(
id int,
  cust_id int,
  name varchar(255),
  city varchar(255)
)

INSERT INTO customer(id, cust_id, name, city)
VALUES(1 ,1001 ,'Foo' ,'Mumbai'),
(2 ,1002 ,'Bar' ,'Pune'),
(3 ,1003 ,'Baz' ,'Bengaluru'),
(4 ,1004 ,'Foobar' ,'Delhi')


select * from customer
SELECT * FROM orders
```

#### Queries:


##### -- #1- Select 2nd costliest order for cust_id 1004 from customer table
`select * from orders where cust_id = '1004' order by price DESC limit 1,1`

##### -- #2 - Select all cust_id and their costliest orders from customer table
`SELECT cust_id, max(price) as 'costliest order' FROM orders GROUP by cust_id`


##### -- #3 - select the costliest order for all customers with their names and city
```
SELECT c.cust_id, c.name, c.city, max(o.price) as 'costliest order' 
from orders o left join customer c on c.cust_id = o.cust_id
GROUP by 1,2,3
```



