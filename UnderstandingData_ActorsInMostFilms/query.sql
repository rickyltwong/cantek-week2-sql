SELECT a.first_name, a.last_name, DENSE_RANK() OVER (ORDER BY COUNT(1) DESC) AS rank, COUNT(1) AS film_count
FROM actor a
         JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY film_count DESC;