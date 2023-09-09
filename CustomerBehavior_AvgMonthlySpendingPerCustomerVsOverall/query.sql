WITH cte_customer_month_avg AS (SELECT customer_id,
                                       EXTRACT(MONTH FROM payment_date) AS month,
                                       AVG(amount)                      AS cust_month_avg
                                FROM payment
                                GROUP BY customer_id, month
                                ORDER BY customer_id, month),

     cte_month_avg AS (SELECT AVG(amount) AS month_avg, EXTRACT(MONTH FROM payment_date) AS month
                       FROM payment
                       GROUP BY month
                       ORDER BY month)

SELECT customer_id,
       month,
       ROUND(cust_month_avg, 2) AS customer_monthly_average,
       ROUND(month_avg, 2)      AS monthly_average
FROM cte_customer_month_avg
         JOIN cte_month_avg USING (month)
ORDER BY customer_id, month;
