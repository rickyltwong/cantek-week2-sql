-- CustomerBehavior_AvgMonthlySpendingPerCustomerVsOverall

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


-- CustomerBehavior_MonthlyRentalPerCustomer

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


-- CustomerBehavior_RevenuePerDistrict

SELECT c.city, a.district, SUM(p.amount) AS revenue, RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank
FROM address a
         JOIN city c ON a.city_id = c.city_id
         JOIN country co ON c.country_id = co.country_id
         JOIN customer cu ON a.address_id = cu.address_id
         JOIN payment p ON cu.customer_id = p.customer_id
GROUP BY c.city, a.district
ORDER BY revenue DESC
LIMIT 20;

-- FeatureEngineering_PredictCustomerChurn

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


-- FeatureEngineering_RatingDescription

CREATE TEMPORARY TABLE rating_description (
    rating VARCHAR(10),
    description VARCHAR(100)
);

INSERT INTO rating_description VALUES
    ('G', 'General Audiences'),
    ('PG', 'Parental Guidance Suggested'),
    ('PG-13', 'Parents Strongly Cautioned'),
    ('R', 'Restricted'),
    ('NC-17', 'Adults Only');

CREATE TEMPORARY TABLE film_rating_description (
    film_id INT,
    rating VARCHAR(10),
    description VARCHAR(100)
);

INSERT INTO film_rating_description
SELECT
    f.film_id,
    f.rating,
    rd.description
FROM
    film f
    JOIN rating_description rd ON f.rating = rd.rating::mpaa_rating;

SELECT
    rd.film_id,
    f.title,
    rd.rating,
    rd.description
FROM
    film_rating_description rd JOIN film f ON rd.film_id = f.film_id;

-- FinancialPerformance_MonthlyRevenueChange

WITH cte AS (SELECT EXTRACT(YEAR FROM
                            payment_date)
                                                                                        AS YEAR
                  , EXTRACT(MONTH FROM
                            payment_date)                                               AS MONTH
                  , SUM(amount)                                                         AS revenue
                  , SUM(amount) - LEAD(SUM(amount)
        , 1)
                                  OVER (ORDER BY EXTRACT(MONTH FROM payment_date) DESC) AS revenue_change
             FROM payment
             GROUP BY YEAR, MONTH)
SELECT YEAR, MONTH, revenue, ROUND(revenue_change * 100 / LAG(revenue, 1) OVER (ORDER BY MONTH), 2) AS percentage_change
FROM cte
ORDER BY YEAR, MONTH DESC;

-- FinancialPerformance_RevenuePerFilmCategory

SELECT c.name, SUM(p.amount) AS revenue, RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank
FROM category c
         JOIN film_category fc ON c.category_id = fc.category_id
         JOIN inventory i ON fc.film_id = i.film_id
         JOIN rental r ON i.inventory_id = r.inventory_id
         JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY revenue DESC;

-- FinancialStrategy_PricingStrategyForFilmRentals

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

-- UnderstandingData_ActorsInMostFilms

SELECT a.first_name, a.last_name, DENSE_RANK() OVER (ORDER BY COUNT(1) DESC) AS rank, COUNT(1) AS film_count
FROM actor a
         JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY film_count DESC;

-- UnderstandingData_AvgRentalDurationPerCategory

WITH cte AS (SELECT c.category_id,
                    c.name                                            AS name,
                    EXTRACT(DAY FROM (r.return_date - r.rental_date)) AS rental_duation
             FROM rental r
                      JOIN inventory i ON r.inventory_id = i.inventory_id
                      JOIN film f ON i.film_id = f.film_id
                      JOIN film_category fc ON f.film_id = fc.film_id
                      JOIN category c ON fc.category_id = c.category_id
             WHERE r.return_date IS NOT NULL)
SELECT name, ROUND(AVG(rental_duation), 2) AS average_rental_duration_in_days
FROM cte
GROUP BY name
ORDER BY average_rental_duration_in_days DESC;

-- UnderstandingData_FilmsPerCategory

SELECT c.name AS category_name, COUNT(1) AS film_count
FROM category c
         JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY film_count DESC;

-- UnderstandingData_MostPopularFilms

SELECT f.film_id, f.title, COUNT(1) AS rental_count
FROM film f
         JOIN film_category fc ON f.film_id = fc.film_id
         JOIN inventory i ON fc.film_id = i.film_id
         JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY COUNT(1) DESC
LIMIT 5;

