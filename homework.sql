# MySQL Homework
# 1a
select first_name, last_name from actor;

# 1b
select concat(first_name, ' ', last_name) as 'Actor Name'
from actor;

# 2a
select * from actor
where first_name = ("JOE");

# 2b
select * from actor
where last_name like '%GEN%';

# 2c
select * from actor
where last_name like '%LI%'
order by last_name, first_name;

# 2d
select country_id, country from country
where country in ("Afghanistan", "Bangladesh", "China");

# 3a
ALTER TABLE actor 
ADD COLUMN `description` BLOB NULL AFTER `last_update`;

# 3b
ALTER TABLE actor 
drop column `description`;

# 4a
select last_name, count(last_name) from actor
group by last_name;

# 4b
select last_name, count(last_name) from actor
group by last_name
having count(last_name) >= 2;

# 4c
update actor
set first_name = "HARPO"
where first_name = "GROUCHO" AND last_name = "WILLIAMS";

# 4d
set sql_safe_updates = 0;
update actor
set first_name = "GROUCHO"
where first_name = "HARPO";
set sql_safe_updates = 1;

# 5a***********************
show create table address;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

# 6a
select staff.first_name, staff.last_name, address.address
from staff
join address on staff.address_id=address.address_id;

# 6b
select staff.first_name, staff.last_name, sum(payment.amount)
from staff
join payment on staff.staff_id = payment.staff_id
where payment.payment_date like "2005-08-%"
group by last_name;

# 6c
select film.title, count(film_actor.actor_id) as "Number of actors"
from film
join film_actor on film.film_id = film_actor.film_id
group by film.title;

# 6d
select count(inventory.film_id), film.title from inventory
join film on inventory.film_id = film.film_id
where film.title = "Hunchback Impossible";

# 6e
select customer.first_name, customer.last_name, sum(payment.amount) as "Total Amount Paid"
from customer
join payment on customer.customer_id = payment.customer_id
group by last_name;

# 7a
SELECT title 
FROM film
WHERE language_id in 
(
	SELECT language_id 
    FROM language
	WHERE name = "English"
)and title like "K%" or title like "Q%";

# 7b
select first_name, last_name
from actor
where actor_id in
(
select actor_id 
from film_actor
where film_id in
(
select film_id 
from film
where title = 'Alone Trip'
)
);
    
# 7c
select customer.first_name, customer.last_name, customer.email
from customer
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
where country = "Canada";

# 7d
select title
from film
where film_id in
(
select film_id 
from film_category
where category_id in
(
select category_id
from category
where name = "Family"
)
);

# 7e
select film.title, count(distinct rental_id) as 'times rented'
from rental
join inventory on rental.inventory_id = inventory.inventory_id 
join film on inventory.film_id = film.film_id
group by film.title
order by count(distinct rental_id) desc;

# 7f
select store.store_id, sum(amount) as '$$$'
from payment
join rental on payment.rental_id = rental.rental_id
join inventory on inventory.inventory_id = rental.inventory_id
join store on store.store_id = inventory.store_id
group by store.store_id;

# 7g
select store.store_id, city.city, country.country
from country
join city on city.country_id = country.country_id
join address on address.city_id = city.city_id
join store on address.address_id = store.address_id

# 7h
select c.name 'Genre', sum(p.amount) as 'Gross'
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by c.name 
order by gross desc limit 5;

# 8a
create view top_gross_by_genre as
select c.name 'Genre', sum(p.amount) as 'Gross'
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by c.name 
order by gross desc limit 5;

# 8b
select * from top_gross_by_genre

# 8c
drop view top_gross_by_genre


