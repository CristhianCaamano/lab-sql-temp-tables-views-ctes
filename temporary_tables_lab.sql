USE sakila;

CREATE VIEW customer_rental_summary AS
SELECT 
    cu.customer_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.email,
    COUNT(r.rental_id) AS rental_count
FROM customer cu
JOIN rental r ON cu.customer_id = r.customer_id
GROUP BY cu.customer_id;

SELECT * FROM customer_rental_summary;

-- 2
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

SELECT * FROM customer_payment_summary;

-- 3
WITH customer_summary AS (
    SELECT 
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid,
        (cps.total_paid / crs.rental_count) AS average_payment_per_rental
    FROM customer_rental_summary crs
    JOIN customer_payment_summary cps ON crs.customer_id = cps.customer_id)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(average_payment_per_rental, 2) AS average_payment_per_rental
FROM customer_summary;