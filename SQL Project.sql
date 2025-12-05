Create Database Banking;
use Banking;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    age INT,
    city VARCHAR(40)
);

INSERT INTO customers (customer_id, customer_name, age, city) VALUES
(1, 'Rajesh Kumar', 32, 'Delhi'),
(2, 'Anita Mehta', 28, 'Mumbai'),
(3, 'Vikram Singh', 45, 'Bangalore'),
(4, 'Simran Kaur', 37, 'Chandigarh'),
(5, 'Amit Das', 30, 'Kolkata');


CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(20),
    balance INT,
    opened_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO accounts (account_id, customer_id, account_type, balance, opened_date) VALUES
(101, 1, 'Savings', 50000, '2022-01-10'),
(102, 2, 'Current', 120000, '2021-11-04'),
(103, 3, 'Savings', 90000, '2023-03-12'),
(104, 4, 'Savings', 45000, '2022-08-18'),
(105, 5, 'Current', 70000, '2021-12-20');


CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    transaction_type VARCHAR(20),
    amount INT,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO transactions (transaction_id, account_id, transaction_date, transaction_type, amount) VALUES
(10001, 101, '2024-01-10', 'Deposit', 15000),
(10002, 101, '2024-01-11', 'Withdrawal', 5000),
(10003, 102, '2024-01-11', 'Deposit', 30000),
(10004, 102, '2024-01-13', 'Withdrawal', 25000),
(10005, 103, '2024-01-14', 'Deposit', 20000),
(10006, 104, '2024-01-15', 'Withdrawal', 10000),
(10007, 105, '2024-01-15', 'Deposit', 25000),
(10008, 105, '2024-01-16', 'Withdrawal', 5000),
(10009, 101, '2024-01-17', 'Withdrawal', 20000),
(10010, 103, '2024-01-17', 'Deposit', 5000);

select * from customers;
select * from accounts;
select * from transactions;

select sum(balance) as total_balance
from accounts;

    -- BASIC LEVEL
    
-- 1.Show all customers who live in Delhi.
-- 2.Display all Savings account details.
-- 3.List all transactions done on 2024-01-15.
-- 4.Get the names of customers whose age is greater than 30.
-- 5.Show all deposits (transaction_type = 'Deposit').


-- 1.Show all customers who live in Delhi.
         select * from customers 
		 where city = 'Delhi';
-- 2.Display all Savings account details.
          select * from accounts
          where account_type = 'Savings';
-- 3.List all transactions done on 2024-01-15.
          select * from transactions
          where transaction_date ='2024-01-15';
-- 4.Get the names of customers whose age is greater than 30.
		   select * from customers
           where age >= 30;
-- 5.Show all deposits (transaction_type = 'Deposit').
            select * from transactions
            where transaction_type = 'Deposit' ;
            
-- INTERMEDIATE LEVEL

-- 1.Find the total balance of each customer.
-- 2.List the total amount deposited by each account.
-- 3.Display highest transaction amount for every customer.
-- 4.Show customers who have Current accounts.
-- 5.Get city-wise number of customers.

-- 1.Find the total balance of each customer.
            select customers.customer_name , 
            sum(accounts.balance) as total_balance
            from customers
            join accounts on customers.customer_id = accounts.customer_id 
            group by customers.customer_name;
-- 2.List the total amount deposited by each account. 
             select sum(amount) as total_amount , account_id
             from transactions
             where transaction_type = 'Deposit'
             group by account_id;
-- 3.Display highest transaction amount for every customer.
			SELECT c.customer_id, c.customer_name,
			MAX(t.amount) AS highest_transaction
			FROM customers c
            JOIN accounts a ON c.customer_id = a.customer_id
			JOIN transactions t ON a.account_id = t.account_id
			GROUP BY c.customer_id, c.customer_name;
-- 4.Show customers who have Current accounts.
            select customers.customer_name , accounts.account_type
			from customers
            join accounts on customers.customer_id = accounts.customer_id
            where accounts.account_type = 'Current';
-- 5.Get city-wise number of customers.
            select city ,
            count(*) as number_of_customers
            from customers
            group by city;
            
-- JOIN-BASED QUESTIONS

-- 1.List all transactions with customer names.
-- 2.Display customers who made a withdrawal greater than 10,000.
-- 3.Show account_type and total transactions for each account.
-- 4.List customers who performed at least one transaction.
-- 5.Display customers who never made any transaction.     

       
-- 1.List all transactions with customer names.
			       SELECT 
                   t.transaction_id, c.customer_name, t.transaction_type, t.amount,
				   t.t ransaction_date
                   FROM transactions t
				   JOIN accounts a ON t.account_id = a.account_id
                   JOIN customers c ON a.customer_id = c.customer_id;
-- 2.Display customers who made a withdrawal greater than 10,000.
                  select c.customer_name , t.amount
                  from transactions t
                  join accounts a on t.account_id = a.account_id 
                  join customers c on a.customer_id = c.customer_id 
                  where t.transaction_type  = 'Withtdrawal' 
                  and t.amount > 10000;
-- 3.Show account_type and total transactions for each account.
               select accounts.account_type , accounts.account_id  ,
               count(transactions.transaction_id) as total_transactions
               from accounts 
               left join transactions on accounts.account_id = transactions.account_id 
               group by accounts.account_type , accounts.account_id;
-- 4.List customers who performed at least one transaction.
               SELECT DISTINCT
			   c.customer_name
               FROM customers c
               JOIN accounts a ON c.customer_id = a.customer_id
               JOIN transactions t ON a.account_id = t.account_id;
-- 5.Display customers who never made any transaction.
               SELECT 
               c.customer_name
               FROM customers c
               LEFT JOIN accounts a ON c.customer_id = a.customer_id
               LEFT JOIN transactions t ON a.account_id = t.account_id
               WHERE t.transaction_id IS NULL;
               
 -- AGGREGATION & GROUP BY
 
-- 1.Find the total deposits and total withdrawals separately.
-- 2.Show the monthly total transaction amount.
-- 3.Count how many transactions each account has done.
-- 4.Find the average transaction amount per account.
-- 5.List top 3 accounts with highest total withdrawals. 

-- 1.Find the total deposits and total withdrawals separately.
              select  transaction_type , sum(amount) as total_amount 
              from transactions
              group by transaction_type;
-- 2.Show the monthly total transaction amount.
               SELECT 
			   DATE_FORMAT(transaction_date, '%Y-%m') AS month,
               SUM(amount) AS total_amount
               FROM transactions
               GROUP BY month
               ORDER BY month;
-- 3.Count how many transactions each account has done.
              select count(*) transaction_count ,
              account_id 
              from transactions
              group by account_id;
-- 4.Find the average transaction amount per account.
              select avg(amount) , account_id
              from transactions
              group by account_id;
-- 5.List top 3 accounts with highest total withdrawals. 
              SELECT 
              account_id,
              SUM(amount) AS total_withdrawal
              FROM transactions
              WHERE transaction_type = 'Withdrawal'
              GROUP BY account_id
              ORDER BY total_withdrawal DESC
              LIMIT 3;
              
-- ADVANCED 

-- 1.Detect transactions where the withdrawal amount is more than the account balance.
-- 2.Find customers with multiple transactions on the same day.
-- 3.List accounts where balance < 50000 after transactions.
-- 4.Identify potential fraud where total transactions per day exceed 50,000.
-- 5.Find customers who opened an account before 2022.

-- 1.Detect transactions where the withdrawal amount is more than the account balance.
                  select t.transaction_id,
                  t.account_id,
                  t.amount as withdrawal_amount,
                  a.balance as account_balance
                  from transactions t
                  join accounts a on t.account_id = a.account_id 
                  where t.transaction_type = 'withdrawal'
                  and t.amount > a.balance;
-- 2.Find customers with multiple transactions on the same day.
				 SELECT 
				 c.customer_name,
				 t.transaction_date,
                 COUNT(*) AS total_transactions
                 FROM transactions t
                 JOIN accounts a ON t.account_id = a.account_id
                 JOIN customers c ON a.customer_id = c.customer_id
                 GROUP BY c.customer_name, t.transaction_date
                 HAVING COUNT(*) >= 2;
-- 3.List accounts where balance < 50000 after transactions.
                   SELECT 
                   a.account_id,
                   a.customer_id,
                   a.balance 
                   + IFNULL(SUM(CASE WHEN t.transaction_type = 'Deposit' THEN t.amount END), 0)
                   - IFNULL(SUM(CASE WHEN t.transaction_type = 'Withdrawal' THEN t.amount END), 0)
                  AS updated_balance
                  FROM accounts a
                  LEFT JOIN transactions t 
                  ON a.account_id = t.account_id
                  GROUP BY a.account_id, a.customer_id, a.balance
                  HAVING updated_balance < 50000;
-- 4.Identify potential fraud where total transactions per day exceed 50,000.
				SELECT 
				transaction_date,
                SUM(amount) AS total_amount
                FROM transactions
                GROUP BY transaction_date
                HAVING total_amount > 50000;
-- 5.Find customers who opened an account before 2022.
                 SELECT 
                 c.customer_name,
                a.account_id,
				a.opened_date
                FROM accounts a
               JOIN customers c ON a.customer_id = c.customer_id
               WHERE a.opened_date < '2022-01-01';
               
-- WINDOW FUNCTION QUESTIONS 

-- 1.Rank transactions by amount for each customer.
-- 2.Show cumulative total of transactions per account.
-- 3.Find the top 2 highest deposits per customer.
-- 4.Calculate running balance per account.
-- 5.Assign row numbers to all transactions per account.

-- 1.Rank transactions by amount for each customer.
             SELECT 
            c.customer_name,
            t.transaction_id,
            t.amount,
            t.transaction_type,
            RANK() OVER (PARTITION BY c.customer_id ORDER BY t.amount DESC) AS amount_rank
           FROM transactions t
           JOIN accounts a ON t.account_id = a.account_id
           JOIN customers c ON a.customer_id = c.customer_id
           ORDER BY c.customer_name, amount_rank;
-- 2.Show cumulative total of transactions per account.
             SELECT account_id, transaction_id,
             transaction_date, amount,
			SUM(amount) OVER (PARTITION BY account_id ORDER BY transaction_date) AS cumulative_total
			FROM transactions;
-- 3.Find the top 2 highest deposits per customer.
              SELECT *
              FROM (
              SELECT 
        c.customer_name,
        t.transaction_id,
        t.amount,
        ROW_NUMBER() OVER(
            PARTITION BY c.customer_id 
            ORDER BY t.amount DESC
        ) AS rn
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    JOIN customers c ON c.customer_id = a.customer_id
    WHERE t.transaction_type = 'Deposit'
) x
WHERE rn <= 2;
-- 4.Calculate running balance per account.
                                         SELECT
                     account_id,
                     transaction_id,
                     transaction_date,
                     transaction_type,
                      amount,
                    SUM(
                 CASE 
               WHEN transaction_type='Deposit' THEN amount
                 WHEN transaction_type='Withdrawal' THEN -amount
                 ELSE 0 
               END ) OVER (PARTITION BY account_id ORDER BY transaction_date)
            AS running_balance
          FROM transactions;
-- 5.Assign row numbers to all transactions per account.
              SELECT
              account_id,
              transaction_id,
              ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY transaction_date) AS row_num
              FROM transactions;
          
          




 
                  
                
                 

                  

              
              
              

              


                 
                 
              
                               
                                      
                  

              
              
              
              
              
              
              
              
              
			






