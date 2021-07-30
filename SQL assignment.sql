CREATE TABLE Agent (
    Agent_id int,
    Name varchar(255)
);
insert into agent(Agent_id,Name)
values(1,'Vijay');
insert into agent(Agent_id,Name)
values(2,'Rajesh'),
(3,'Satish'),
(4,'Anji');
Select * from  Agent;


create table Case_transaction_details(
Case_id int,
Stage varchar(255),
Login_Time varchar(255),
Logout_time varchar(255),
Agent_id int not null,
Status varchar(255)
);
insert into Case_transaction_details values(101,'Maker',"5/11/2019 10:20","10:30",2,'Success'),
(102,'Maker', "10:25","10:35",1,'Success'),
(103,'Maker', "10:40","10:50",2,'Success'),
(101,'Checker', "10:45","11:00",3,'Success'),
(101,'Approver', "11:15","11:30",2,'Success'),
(102,'Checker', "10:50","11:00",1,'Reject'),
(102,'Maker', "11:15","11:45",4,'Reverify'),
(103,'Checker', "11:30","11:40",2,'Reject');

select * from Case_transaction_details;

/*1. How many unique cases per day?*/
SELECT DISTINCT Case_id FROM Case_transaction_details;

/*2. Case Id which is rejected by checker but still not reverified?*/
SELECT Case_id 
FROM Case_transaction_detail  
WHERE Status = 'Reject' and status != 'Reverify';

/*3. Top Agent names with who processed more applications?*/
select Agent.Agent_id,Agent.Name,Case_transaction_details.Agent_id,Case_transaction_details.Status
from agent left join Case_transaction_details
ON agent.Agent_Id = Case_transaction_details.Table1
GROUP BY agent.Name,agent.Agent_Id
order by cnt desc limit 1;

/*Problem 2:*/

use superstores;
select * from cust_dimen;
select * from market_fact;
select * from orders_dimen;
select * from prod_dimen;

/*1. Write a query to display the Customer_Name and Customer Segment using alias name
“Customer Name", "Customer Segment" from table Cust_dimen.*/
select Customer_Name as "CustomerName" , Customer_Segment as "CustomerSegment"
from Cust_dimen;

/*2. Write a query to find all the details of the customer from the table cust_dimen order
by desc.*/
SELECT * FROM cust_dimen
ORDER BY Customer_Name DESC;

/*3. Write a query to get the Order ID, Order date from table orders_dimen where ‘Order
Priority’ is high.*/
select* from orders_dimen;
select Order_ID,Order_Date from orders_dimen
where Order_Priority='High';

/*4. Find the total and the average sales (display total_sales and avg_sales)*/
SELECT SUM(Sales) AS total_sales,avg(Sales) as avg_sales
from market_fact;

/*5. Write a query to get the maximum and minimum sales from maket_fact table.*/
select MAX(sales), MIN(sales)
FROM
    market_fact;

/*6. Display the number of customers in each region in decreasing order of
no_of_customers. The result should contain columns Region, no_of_customers.*/
Select * from cust_dimen;
select Region,Count( DISTINCT cust_id) as no_of_Customers
from cust_dimen
group by Region
Order by Count( DISTINCT cust_id) desc ;

/*7. Find the region having maximum customers (display the region name and
max(no_of_customers)*/
select Region,Count( DISTINCT cust_id) as no_of_Customers
from cust_dimen
group by Region 
order by Count( DISTINCT cust_id) desc
limit 1;
  
 /*8. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the
number of tables purchased (display the customer name, no_of_tables purchased)*/
select cust_dimen.Customer_name, count(market_fact.Prod_id)
from cust_dimen join
     market_fact 
     on market_fact.Cust_id = cust_dimen.Cust_id join
     prod_dimen 
     on prod_dimen.Prod_id = market_fact.Prod_id 
where cust_dimen.Region = 'ATLANTIC' and prod_dimen.Product_Sub_Category = 'TABlES'
group by cust_dimen.Customer_name;

/*9. Find all the customers from Ontario province who own Small Business. (display the
customer name, no of small business owners)*/
use superstores;
SET @row_number = 0;
SELECT *, (@row_number:=@row_number + 1) AS num
FROM
    cust_dimen
WHERE
    province = 'ontario'
        AND customer_segment = 'small business'
GROUP BY cust_id;



/*10. Find the number and id of products sold in decreasing order of products sold (display
product id, no_of_products sold)*/
SELECT 
    prod_id, SUM(order_quantity) AS no_of_products_sold
FROM
    market_fact
GROUP BY prod_id
ORDER BY SUM(order_quantity) DESC;

/*11. Display product Id and product subcategory whose product category belongs to
Furniture and TechnologyTechnlogy. The result should contain columns of product id,
product subcategory.*/
SELECT 
    product_sub_category, prod_id, product_category
FROM
    prod_dimen
WHERE
    product_category = 'technology'
        OR product_category = 'furniture';

/*12. Display the product categories in descending order of profits (display the product
category wise profits i.e. product_category, profits)?*/
SELECT product_category, SUM(profit) AS total_profit
FROM prod_dimen
INNER JOIN market_fact ON market_fact.prod_id = prod_dimen.prod_id
GROUP BY product_category
ORDER BY SUM(profit) DESC;


/*13. Display the product category, product sub-category and the profit within each
subcategory in three columns.*/
SELECT 
    product_category,product_sub_category, SUM(profit) AS total_profit
FROM
    prod_dimen
        INNER JOIN
    market_fact ON market_fact.prod_id = prod_dimen.prod_id
GROUP BY product_sub_category
ORDER BY SUM(profit) DESC;


/*14. Display the order date, order quantity and the sales for the order.*/
SELECT  order_date, SUM(order_quantity), SUM(sales)
FROM orders_dimen
INNER JOIN market_fact ON market_fact.ord_id = orders_dimen.ord_id
GROUP BY order_date;

/*15. Display the names of the customers whose name contains the
i) Second letter as ‘R’
ii) Fourth letter as ‘D’*/
SELECT 
    customer_name
FROM
    cust_dimen
WHERE
    customer_name LIKE '_R%' or customer_name LIKE '___D%';

/*16. Write a SQL query to make a list with Cust_Id, Sales, Customer Name and their region
where sales are between 1000 and 5000.*/
SELECT customer_name, cust_dimen.cust_id, sales, region
FROM cust_dimen
inner JOIN market_fact ON cust_dimen.cust_id = market_fact.cust_id
WHERE sales BETWEEN 1000 AND 5000;



/*17. Write a SQL query to find the 3 rd highest sales.*/
SELECT sales
FROM market_fact
ORDER BY sales DESC
LIMIT 2,1;/*The clause LIMIT n-1, 1 returns 1 row starting at the row n.*/

/*18. Where is the least profitable product-subcategory shipped the most? For the least
profitable product sub-category, display the region-wise no_of_shipments and the
profit made in each region in decreasing order of profits (i.e. region, no_of_shipments,
profit_in_each_region)*/
 SELECT 
    product_sub_category,
    SUM(profit) as Total_Profit,
    region,
    COUNT(region) AS number_of_shipments
FROM
    market_fact
        INNER JOIN
    prod_dimen ON prod_dimen.prod_id = market_fact.prod_id
        INNER JOIN
    orders_dimen ON orders_dimen.ord_id = market_fact.ord_id
        INNER JOIN
    cust_dimen ON cust_dimen.cust_id = market_fact.cust_id
WHERE
    product_sub_category = (select product_sub_category
from market_fact
    INNER JOIN
    prod_dimen ON prod_dimen.prod_id = market_fact.prod_id
order by profit asc
limit 1)
GROUP BY region
ORDER BY Total_profit ASC;




use players;
select * from ball_by_ball;
select * from batsman_scored;
select * from extra_runs;
select * from players.match;
select * from player;
select * from team;
select * from wicket_taken;

/*Problem 3:*/
/*1. List the names of all left-handed batsmen from England. Order the results
alphabetically.*/
SELECT player_name FROM player
WHERE batting_hand = 'Left-hand bat' and country_name = 'England'
order by player_name asc;


/*2. List the names and age (in years, should be an integer) as on 2018-12-02 (12th Feb
2018) of all bowlers with skill “Legbreak googly” who are 28 or more in age. Order
the result in decreasing order of their ages. Resolve ties alphabetically.*/

SELECT * FROM player;
select p.player_id, p.player_name, p.age, p.dob, p.bowling_skill
from ( select player_id, player_name, TIMESTAMPDIFF(year,dob,'2018-12-02') as age, dob , bowling_skill from player) as p
where p.age>=28 and p.bowling_skill = "Legbreak googly"
order by p.age desc, p.player_name asc;

/*3. List the match ids and toss winning team IDs where the toss winner of a match
decided to bat first. Order results in increasing order of match ids.*/
SELECT match_id, toss_winner FROM players.match 
WHERE toss_decision = 'bat' ORDER BY match_id;

/*4. In the match with match id 335987, list the over ids and runs scored where at most
7 runs were scored. Order the over ids in decreasing order of runs scored. Resolve
ties by listing the over ids in increasing order.*/
select over_id , extra_runs from  extra_runs
 where match_id ='335987' and extra_runs < '7'
 order by extra_runs desc, over_id asc;

/*5. List the names of those batsmen who were bowled at least once in alphabetical
order of their names.*/
SELECT player_name FROM player 
WHERE player_id IN (SELECT DISTINCT player_out FROM wicket_taken where kind_out = 'bowled') 
ORDER BY player_name;








 
  
  


