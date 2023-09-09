SELECT c.customer_id,
       COUNT(r.rental_id)                                                           AS rental_count,
       SUM(p.amount)                                                                AS total_amount,
       DATE_PART('year', r.rental_date) || '-' || DATE_PART('month', r.rental_date) AS month
FROM customer C
         JOIN rental r
              ON C.customer_id = r.customer_id
         JOIN payment p ON r.rental_id = p.rental_id
GROUP BY C.customer_id, month
ORDER BY rental_count DESC
