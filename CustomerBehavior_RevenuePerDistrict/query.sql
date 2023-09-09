SELECT c.city, a.district, SUM(p.amount) AS revenue, RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank
FROM address a
         JOIN city c ON a.city_id = c.city_id
         JOIN country co ON c.country_id = co.country_id
         JOIN customer cu ON a.address_id = cu.address_id
         JOIN payment p ON cu.customer_id = p.customer_id
GROUP BY c.city, a.district
ORDER BY revenue DESC
LIMIT 20;