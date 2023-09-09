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