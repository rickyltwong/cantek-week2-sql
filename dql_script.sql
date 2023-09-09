-- Calculate the monthly revenue and also the percentage change in revenue from the previous month.

WITH cte AS (SELECT EXTRACT(YEAR FROM
                            payment_date)                                               AS year
                  , EXTRACT(MONTH FROM
                            payment_date)                                               AS month
                  , SUM(amount)                                                         AS revenue
                  , SUM(amount) - LEAD(SUM(amount), 1)
                                  OVER (ORDER BY EXTRACT(MONTH FROM payment_date) DESC) AS revenue_change
             FROM payment
             GROUP BY year, month)
SELECT year, month, revenue, ROUND(revenue_change * 100 / LAG(revenue, 1) OVER (ORDER BY month), 2) AS percentage_change
FROM cte
ORDER BY year, month DESC;

-- Find the number of films in each category

SELECT c.name, COUNT(1) AS film_count
FROM category c
         JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY film_count DESC;

-- Query the films that have the top 5 highest number of rentals

SELECT f.film_id, f.title, COUNT(1) AS rental_count
FROM film f
         JOIN film_category fc ON f.film_id = fc.film_id
         JOIN inventory i ON fc.film_id = i.film_id
         JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY COUNT(1) DESC
LIMIT 5;

-- query the revenue of each category of film

SELECT c.name, SUM(p.amount) AS revenue
FROM category c
         JOIN film_category fc ON c.category_id = fc.category_id
         JOIN inventory i ON fc.film_id = i.film_id
         JOIN rental r ON i.inventory_id = r.inventory_id
         JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY revenue DESC;

-- Find the decision rule for the rental rate
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

-- Visulizing the data in the table above, we can see that the rental rate is determined by the rental duration,
-- For most of the film, the rental rate is fixed for the first 3 days, and then it increases by 1 dollar per day

-- Find the number of rentals for each customer for each month

SELECT c.customer_id,
       COUNT(r.rental_id)                                                           AS rental_count,
       DATE_PART('year', r.rental_date) || '-' || DATE_PART('month', r.rental_date) AS MONTH
FROM customer C
         JOIN rental r
              ON C.customer_id = r.customer_id
GROUP BY C.customer_id, MONTH
ORDER BY rental_count DESC;

-- Rank the actor based on the number of films they have acted in

SELECT a.first_name, a.last_name, DENSE_RANK() OVER (ORDER BY COUNT(1) DESC) AS rank, COUNT(1) AS film_count
FROM actor a
         JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY film_count DESC;

-- Add a column of rating description of the film (in a view)

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

SELECT customer_id, month, ROUND(cust_month_avg, 2) AS customer_monthly_average, ROUND(month_avg,2) AS monthly_average
FROM cte_customer_month_avg
         JOIN cte_month_avg USING (month)
ORDER BY customer_id, month;

-- Rank the revenue of each district where the customer lives

SELECT c.customer_id,
       COUNT(r.rental_id)                                                           AS rental_count,
       SUM(p.amount)                                                                AS total_amount,
       DATE_PART('year', r.rental_date) || '-' || DATE_PART('month', r.rental_date) AS MONTH
FROM customer C
         JOIN rental r
              ON C.customer_id = r.customer_id
         JOIN payment p ON r.rental_id = p.rental_id
GROUP BY C.customer_id, MONTH
ORDER BY rental_count DESC;


