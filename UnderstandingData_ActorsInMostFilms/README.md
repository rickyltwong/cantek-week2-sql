# UnderstandingData_ActorsInMostFilms

## Objective

The objective of this query is to find the actors who appear in the most films.

## Query

```sql
SELECT a.first_name, a.last_name, DENSE_RANK() OVER (ORDER BY COUNT(1) DESC) AS rank, COUNT(1) AS film_count
FROM actor a
         JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY film_count DESC;
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output.

| first\_name | last\_name | rank | film\_count |
| :--- | :--- | :--- | :--- |
| Susan | Davis | 1 | 54 |
| Gina | Degeneres | 2 | 42 |
| Walter | Torn | 3 | 41 |
| Mary | Keitel | 4 | 40 |
| Matthew | Carrey | 5 | 39 |

[Link to the .csv output file](./output.csv)

