-- Quiz Funnel --
-- get a feel of the survey table
SELECT *
FROM survey
LIMIT 10;

-- see the number responses for each question
SELECT question, COUNT(*) AS 'number of responses'
FROM survey
GROUP BY 1
ORDER BY 2 DESC;

-- calculate the percentage of users who answer each question (Google Sheets used separately)

-- Home Try-On Funnel --
-- examine the first five rows of each table --
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

-- create a new table with a certain layout --
-- calculate total conversion, quiz→home_try_on & home_try_on→purchase conversion
-- by aggregating across rows --
WITH funnel AS(
  SELECT DISTINCT q.user_id,
    h.user_id IS NOT NULL AS is_home_try_on,
    h.number_of_pairs,
    p.user_id IS NOT NULL AS is_purchase
FROM quiz q
LEFT JOIN home_try_on h
    ON q.user_id = h.user_id
LEFT JOIN purchase p
    ON q.user_id = p.user_id
) 

SELECT 1.0 * SUM(is_purchase)/ COUNT(user_id) AS total_conversion,
1.0 * SUM(is_home_try_on) / COUNT(user_id) AS quiz_to_home,
1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS home_to_purchase
FROM funnel

-- calculate the difference in purchase rates between customers who had 3 pairs to try on 
-- with ones who had 5 --
WITH funnel AS(
  SELECT DISTINCT q.user_id,
    h.user_id IS NOT NULL AS is_home_try_on,
    h.number_of_pairs,
    p.user_id IS NOT NULL AS is_purchase
FROM quiz q
LEFT JOIN home_try_on h
    ON q.user_id = h.user_id
LEFT JOIN purchase p
    ON q.user_id = p.user_id
) 
SELECT ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on),2) AS three_conversion
FROM funnel
WHERE number_of_pairs = '3 pairs'
SELECT ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on),2) AS five_conversion
FROM funnel
WHERE number_of_pairs = '5 pairs'


