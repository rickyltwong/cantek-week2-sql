# CustomerBehavior_MonthlyRentalPerCustomer

## Objective

This query is to calculate the monthly rental count and total amount per customer in each month.

## Query

```sql
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
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output.

| customer\_id | rental\_count | total\_amount | month |
| :--- | :--- | :--- | :--- |
| 148 | 22 | 100.78 | 2005-7 |
| 102 | 21 | 84.79 | 2005-7 |
| 75 | 20 | 70.8 | 2005-7 |
| 236 | 20 | 73.8 | 2005-7 |
| 354 | 19 | 67.81 | 2005-7 |

[Link to the .csv output file](./output.csv)

