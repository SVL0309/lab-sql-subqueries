# Write SQL queries to perform the following tasks using the Sakila database:

# Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(inventory_id) AS number_of_copies FROM film INNER JOIN inventory USING (film_id) WHERE title = "Hunchback Impossible";
# List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title FROM film WHERE length > (SELECT AVG(length) FROM film);
# Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name FROM actor WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = (SELECT film_id FROM FILM WHERE title = "Alone Trip"));
# Bonus:
# Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT title FROM film WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id = (SELECT category_id FROM category WHERE name = "family"));

# Retrieve the name and email of customers from Canada using both subqueries and joins.
# To use joins, you will need to identify the relevant tables and their primary and foreign keys.
# SELECT first_name, email FROM customer WHERE (SELECT country_id FROM country WHERE )

SELECT first_name, email
FROM customer
INNER JOIN address as a USING (address_id)
INNER JOIN city as c USING (city_id)
INNER JOIN country as co USING (country_id)
WHERE co.country = "Canada";

# Determine which films were starred by the most prolific actor in the Sakila database.
# A prolific actor is defined as the actor who has acted in the most number of films.
# First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.



SELECT f.title
FROM film AS f
JOIN film_actor AS fa ON f.film_id = fa.film_id
JOIN (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
) AS most_active_actor ON fa.actor_id = most_active_actor.actor_id;


# Find the films rented by the most profitable customer in the Sakila database.
# You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT title
FROM film
INNER JOIN inventory AS i USING (film_id)
INNER JOIN rental AS r USING (inventory_id)
INNER JOIN payment AS p USING (rental_id)
WHERE p.customer_id = (
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) = (
    SELECT MAX(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS total_amount_s)
);

# Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
# You can use subqueries to accomplish this.
SELECT customer_id, total_amount_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_amount_spent
    FROM payment
    GROUP BY customer_id) AS total_amount_s
HAVING total_amount_spent > (
SELECT AVG(total_amount_spent) as av_am FROM (
        SELECT SUM(amount) AS total_amount_spent
        FROM payment
        GROUP BY customer_id) AS total_amount_s);
