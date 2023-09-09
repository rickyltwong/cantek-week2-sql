# UnderstandingData_FilmsPerCategory

## Objective

To find out the number of films available in each category.

## Query

```sql
SELECT c.name AS category_name, COUNT(1) AS film_count
FROM category c
         JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY film_count DESC;
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output.

| category\_name | film\_count |
|:---------------| :--- |
| Sports         | 74 |
| Foreign        | 73 |
| Family         | 69 |
| Documentary    | 68 |
| Animation      | 66 |

[Link to the .csv output file](./output.csv)

