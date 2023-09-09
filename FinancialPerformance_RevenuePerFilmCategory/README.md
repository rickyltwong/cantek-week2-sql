# FinancialPerformance_RevenuePerFilmCategory

## Objective

## Query

```sql
SELECT c.name, SUM(p.amount) AS revenue, RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank
FROM category c
         JOIN film_category fc ON c.category_id = fc.category_id
         JOIN inventory i ON fc.film_id = i.film_id
         JOIN rental r ON i.inventory_id = r.inventory_id
         JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY revenue DESC;
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output.

| name | revenue | rank |
| :--- | :--- | :--- |
| Sports | 4892.19 | 1 |
| Sci-Fi | 4336.01 | 2 |
| Animation | 4245.31 | 3 |
| Drama | 4118.46 | 4 |
| Comedy | 4002.48 | 5 |

[Link to the .csv output file](./output.csv)

