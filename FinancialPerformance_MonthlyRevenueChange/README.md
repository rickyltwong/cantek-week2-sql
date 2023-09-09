# FinancialPerformance_MonthlyRevenueChange

## Objective

The objective of this query is to calculate the monthly revenue and the percentage change in revenue compared to the previous month.

## Query

```sql
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
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 4 rows of the output (only 4 rows in the output).

| year | month | revenue | percentage\_change |
| :--- | :--- | :--- | :--- |
| 2007 | 5 | 514.18 | -98.2 |
| 2007 | 4 | 28559.46 | 19.56 |
| 2007 | 3 | 23886.56 | 186 |
| 2007 | 2 | 8351.84 | null |


[Link to the .csv output file](./output.csv)

