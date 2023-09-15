USE sakila; 

        
######### Segmenting customers based on their rental behavior #########

-- We'll define three customer segments based on rental behavior:

	-- Frequent Renters: Customers who have rented more than 30 times.
    
		CREATE TABLE frequent_renters AS
		SELECT customer_id, COUNT(rental_id) AS total_rentals
		FROM rental
		GROUP BY customer_id
		HAVING total_rentals > 30;

	-- Genre Enthusiasts: Customers who frequently rent a specific movie genre (e.g., Action or Comedy).
    
		CREATE TABLE genre_enthusiasts AS
        SELECT c.customer_id, COUNT(r.rental_id) AS action_rentals, categ.name
        FROM customer c
        INNER JOIN rental r ON c.customer_id = r.customer_id
        INNER JOIN inventory inv ON r.inventory_id = inv.inventory_id
        INNER JOIN film_category fc ON inv.film_id = fc.film_id
        INNER JOIN category categ ON fc.category_id = categ.category_id
        GROUP BY c.customer_id, categ.name
        HAVING categ.name = 'Action'; 
    
	-- Occasional Renters: Customers who have rented fewer than 20 times.
    
		CREATE TABLE Occasional_renters AS
		SELECT customer_id, COUNT(rental_id) AS total_rentals
		FROM rental
		GROUP BY customer_id
		HAVING total_rentals < 20;
    
############## Data Exploration ############

-- Exploring the rental behavior of each customer segment in more detail. 

	-- Average rental duration for each segment.
    
    SET SQL_SAFE_UPDATES = 0;
    
		ALTER TABLE frequent_renters 
        ADD COLUMN rental_date DATETIME,
        ADD COLUMN return_date DATETIME,
        ADD COLUMN rental_duration INT; 
        
UPDATE frequent_renters AS freq
JOIN rental AS r ON freq.customer_id = r.customer_id
SET 
    freq.rental_date = r.rental_date,
    freq.return_date = r.return_date,
    freq.rental_duration = TIMESTAMPDIFF(HOUR, r.rental_date, r.return_date)
WHERE freq.customer_id = r.customer_id;
        
		ALTER TABLE genre_enthusiasts 
        ADD COLUMN rental_date DATETIME,
        ADD COLUMN return_date DATETIME,
        ADD COLUMN rental_duration INT; 

UPDATE genre_enthusiasts AS gen
JOIN rental AS r ON gen.customer_id = r.customer_id
SET 
    gen.rental_date = r.rental_date,
    gen.return_date = r.return_date,
    gen.rental_duration = TIMESTAMPDIFF(HOUR, r.rental_date, r.return_date)
WHERE gen.customer_id = r.customer_id;
        
		ALTER TABLE occasional_renters 
        ADD COLUMN rental_date DATETIME,
        ADD COLUMN return_date DATETIME,
        ADD COLUMN rental_duration INT; 
        
UPDATE occasional_renters AS oc
JOIN rental AS r ON oc.customer_id = r.customer_id
SET 
    oc.rental_date = r.rental_date,
    oc.return_date = r.return_date,
    oc.rental_duration = TIMESTAMPDIFF(HOUR, r.rental_date, r.return_date)
WHERE oc.customer_id = r.customer_id;

-- Average rental duration for frequent_renters.

SELECT AVG(rental_duration)
FROM frequent_renters; 

-- Average rental duration for genre_enthusiasts.

SELECT AVG(rental_duration)
FROM genre_enthusiasts; 

-- Average rental duration for occasional_renters.

SELECT AVG(rental_duration)
FROM occasional_renters; 

SELECT *
FROM frequent_renters; 

SELECT *
FROM genre_enthusiasts; 

SELECT *
FROM occasional_renters; 

