SELECT c.name AS category_name, COUNT(1) AS film_count
FROM category c
         JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY film_count DESC;