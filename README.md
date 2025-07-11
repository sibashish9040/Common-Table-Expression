# 📘 SQL Server CTE (Common Table Expressions) 

This repository demonstrates how to use **Common Table Expressions (CTEs)** in SQL Server for recursive queries and hierarchical data analysis.

## 📂 File

- `Common_table_exp.sql`: Contains multiple examples of using CTEs in SQL Server, including:
  - Aggregating customer sales
  - Retrieving the last order date per customer
  - Ranking customers based on total sales
  - Displaying hierarchical employee structures with recursion
- `init-sqlserver-salesdb.sql`: contains the database init:
  - Contains table like Customer, Order, Employee etc. 

---

## 🧠 What I have Learnt:

1. **What is a CTE?**
   - A temporary result set defined within the execution scope of a `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement.

2. **Syntax Overview**
   ```sql
   WITH CTE_Name AS (
       -- Query definition
   )
   SELECT * FROM CTE_Name;
## ✅ Benefits of Using CTEs

- Improved **readability** and **structure**
- Avoids creating **temporary tables**
- Makes **recursive queries** possible 
- Encourages **modular** query writing

---

## 🔧 Syntax

```sql
WITH CTE_Name AS (
    -- Anchor member or non-recursive base query, this won't be included inside the loop
    SELECT ...
    FROM CTE_NAME -- this will be the pert to be in loop
    Break condition
)
SELECT * FROM CTE_Name;
