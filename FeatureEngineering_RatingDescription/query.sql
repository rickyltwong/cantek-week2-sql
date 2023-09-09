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