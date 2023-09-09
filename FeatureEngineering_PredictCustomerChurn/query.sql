-- define churn as not renting for 90 days
SELECT r.customer_id,
       c.first_name,
       c.last_name,
       MAX(r.rental_date)::DATE                            AS last_rental_date,
       EXTRACT(DAY FROM MAX(r.rental_date) - '2005-05-29') AS days_since_rental
FROM rental r
         JOIN customer c ON r.customer_id = c.customer_id
GROUP BY r.customer_id, c.first_name, c.last_name
HAVING EXTRACT(DAY FROM MAX(r.rental_date) - '2005-05-29') >= 90;
