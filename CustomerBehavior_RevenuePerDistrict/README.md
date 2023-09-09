# CustomerBehavior_RevenuePerDistrict

## Objective

The objective of this query is to calculate the revenue per district and rank the districts by revenue.

## Query

```sql
SELECT c.city, a.district, SUM(p.amount) AS revenue, RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank
FROM address a
         JOIN city c ON a.city_id = c.city_id
         JOIN country co ON c.country_id = co.country_id
         JOIN customer cu ON a.address_id = cu.address_id
         JOIN payment p ON cu.customer_id = p.customer_id
GROUP BY c.city, a.district
ORDER BY revenue DESC
LIMIT 20;
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output.

| city | district | revenue | rank |
| :--- | :--- | :--- | :--- |
| Saint-Denis | Saint-Denis | 211.55 | 1 |
| Cape Coral | Florida | 208.58 | 2 |
| Santa Brbara dOeste | So Paulo | 194.61 | 3 |
| Apeldoorn | Gelderland | 191.62 | 4 |
| Molodetno | Minsk | 189.6 | 5 |

[Link to the .csv output file](./output.csv)

