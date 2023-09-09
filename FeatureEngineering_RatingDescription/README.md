# FeatureEngineering_RatingDescription

## Objective

The objective of this query is to create a mapping table for rating and the description, display all film records and their rating descriptions in a temporary table.

## Query

```sql
CREATE TEMPORARY TABLE rating_description (
    rating VARCHAR(10),
    description VARCHAR(100)
);

INSERT INTO rating_description VALUES
    ('G', 'General Audiences'),
    ('PG', 'Parental Guidance Suggested'),
    ('PG-13', 'Parents Strongly Cautioned'),
    ('R', 'Restricted'),
    ('NC-17', 'Adults Only');

CREATE TEMPORARY TABLE film_rating_description (
    film_id INT,
    rating VARCHAR(10),
    description VARCHAR(100)
);

INSERT INTO film_rating_description
SELECT
    f.film_id,
    f.rating,
    rd.description
FROM
    film f
    JOIN rating_description rd ON f.rating = rd.rating::mpaa_rating;

SELECT
    rd.film_id,
    f.title,
    rd.rating,
    rd.description
FROM
    film_rating_description rd JOIN film f ON rd.film_id = f.film_id;
```

[Link to the .sql script file](./query.sql)

## Sample Output

It is to show the first 5 rows of the output.

| film\_id | title | rating | description |
| :--- | :--- | :--- | :--- |
| 277 | Elephant Trojan | PG-13 | Parents Strongly Cautioned |
| 887 | Thief Pelican | PG-13 | Parents Strongly Cautioned |
| 886 | Theory Mermaid | PG-13 | Parents Strongly Cautioned |
| 45 | Attraction Newton | PG-13 | Parents Strongly Cautioned |
| 44 | Attacks Hate | PG-13 | Parents Strongly Cautioned |

[Link to the .csv output file](./output.csv)

