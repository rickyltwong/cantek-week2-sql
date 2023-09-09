SELECT f.film_id, f.title, COUNT(1) AS rental_count
FROM film f
         JOIN film_category fc ON f.film_id = fc.film_id
         JOIN inventory i ON fc.film_id = i.film_id
         JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY COUNT(1) DESC
LIMIT 5;