# UnderstandingData_MostPopularFilms

## Objective

The objective of this query is to find the top 5 most popular films. The popularity is measured by the number of times a film is rented.

## Query

```sql
SELECT f.film_id, f.title, COUNT(1) AS rental_count
FROM film f
         JOIN film_category fc ON f.film_id = fc.film_id
         JOIN inventory i ON fc.film_id = i.film_id
         JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY COUNT(1) DESC
LIMIT 5;
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output (and the query is finding the top 5 films).

| film\_id | title | rental\_count |
| :--- | :--- | :--- |
| 103 | Bucket Brotherhood | 34 |
| 738 | Rocketeer Mother | 33 |
| 382 | Grit Clockwork | 32 |
| 730 | Ridgemont Submarine | 32 |
| 331 | Forward Temple | 32 |


[Link to the .csv output file](./output.csv)

