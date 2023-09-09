WITH cte_rule AS (SELECT f.film_id,
                         fc.category_id,
                         DATE_PART('day', r.return_date - r.rental_date) AS days_of_rental,
                         p.amount
                  FROM rental r
                           JOIN payment p ON r.rental_id = p.rental_id
                           JOIN inventory i ON r.inventory_id = i.inventory_id
                           JOIN film f ON i.film_id = f.film_id
                           JOIN film_category fc ON f.film_id = fc.film_id
                  WHERE DATE_PART('day', r.return_date - r.rental_date) > 0)
SELECT film_id, category_id, days_of_rental, AVG(amount) AS avg_amount
FROM cte_rule
GROUP BY film_id, category_id, days_of_rental
ORDER BY days_of_rental;


select * from category;