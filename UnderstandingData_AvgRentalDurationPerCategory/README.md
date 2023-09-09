# UnderstandingData_AvgRentalDurationPerCategory

## Objective

The objective of this query is to find the average rental duration for each film category.

## Query

```sql
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
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output.

| name | average\_rental\_duration\_in\_days |
| :--- | :--- |
| Sports | 4.7 |
| Games | 4.69 |
| Comedy | 4.66 |
| Sci-Fi | 4.58 |
| Music | 4.57 |

[Link to the .csv output file](./output.csv)

