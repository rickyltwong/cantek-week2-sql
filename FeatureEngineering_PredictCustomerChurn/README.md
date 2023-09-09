# FeatureEngineering_PredictCustomerChurn

## Objective

The objective of this query is to predict customer churn. The query returns the customers who have not rented a movie in the last 90 days.

## Query

```sql
SELECT r.customer_id,
       c.first_name,
       c.last_name,
       MAX(r.rental_date)::DATE                            AS last_rental_date,
       EXTRACT(DAY FROM MAX(r.rental_date) - '2005-05-29') AS days_since_rental
FROM rental r
         JOIN customer c ON r.customer_id = c.customer_id
GROUP BY r.customer_id, c.first_name, c.last_name
HAVING EXTRACT(DAY FROM MAX(r.rental_date) - '2005-05-29') >= 90;
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output.

| customer\_id | first\_name | last\_name | last\_rental\_date | days\_since\_rental |
| :--- | :--- | :--- | :--- | :--- |
| 101 | Peggy | Myers | 2006-02-14 | 261 |
| 337 | Jerry | Jordon | 2006-02-14 | 261 |
| 264 | Gwendolyn | May | 2006-02-14 | 261 |
| 561 | Ian | Still | 2006-02-14 | 261 |
| 521 | Roland | South | 2006-02-14 | 261 |


[Link to the .csv output file](./output.csv)

