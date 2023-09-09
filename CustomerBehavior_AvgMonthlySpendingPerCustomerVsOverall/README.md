# CustomerBehavior_AvgMonthlySpendingPerCustomerVsOverall

## Objective

The objective of this query is to calculate the average monthly spending per customer and compare it to the overall average monthly spending.

## Query

```sql
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
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output.

| customer\_id | month | customer\_monthly\_average | monthly\_average |
| :--- | :--- | :--- | :--- |
| 1 | 2 | 4.56 | 4.14 |
| 1 | 3 | 2.9 | 4.23 |
| 1 | 4 | 4.24 | 4.23 |
| 2 | 2 | 2.99 | 4.14 |
| 2 | 3 | 4.08 | 4.23 |

[Link to the .csv output file](./output.csv)

