-- Employees Table 
CREATE TABLE employees (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    department VARCHAR2(255) NOT NULL
);

-- Insert 10 records 'employees' table 
INSERT INTO employees (name, email, department) VALUES ('John Doe', 'john.doe@example.com', 'Sales');
INSERT INTO employees (name, email, department) VALUES ('Jane Smith', 'jane.smith@example.com', 'Marketing');
INSERT INTO employees (name, email, department) VALUES ('Bob Johnson', 'bob.johnson@example.com', 'Finance');
INSERT INTO employees (name, email, department) VALUES ('Mary Brown', 'mary.brown@example.com', 'Human Resources');
INSERT INTO employees (name, email, department) VALUES ('David Lee', 'david.lee@example.com', 'Engineering');
INSERT INTO employees (name, email, department) VALUES ('Sarah Green', 'sarah.green@example.com', 'Sales');
INSERT INTO employees (name, email, department) VALUES ('Mike Davis', 'mike.davis@example.com', 'Marketing');
INSERT INTO employees (name, email, department) VALUES ('Karen Wilson', 'karen.wilson@example.com', 'Finance');
INSERT INTO employees (name, email, department) VALUES ('Tom Johnson', 'tom.johnson@example.com', 'Human Resources');
INSERT INTO employees (name, email, department) VALUES ('Lisa Chen', 'lisa.chen@example.com', 'Engineering');
commit;

-- Employees Salary Table 
CREATE TABLE employees_salary (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id NUMBER NOT NULL,
    salary NUMERIC(10, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    bonus FLOAT NOT NULL
    );
    
-- Procedure to Generate Sample Data
CREATE OR REPLACE PROCEDURE generate_employees_salary(n IN NUMBER) AS
BEGIN
  FOR i IN 1..n LOOP
    INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus)
    VALUES (FLOOR(DBMS_RANDOM.VALUE(1, 10)), -- generate random employee_id between 1 and 10
            ROUND(DBMS_RANDOM.VALUE(50000, 100000), 2), -- generate random salary between 50000 and 100000 with 2 decimal places
            TRUNC(SYSDATE - DBMS_RANDOM.VALUE(1, 365)), -- generate random start_date between 1 and 365 days ago
            TRUNC(SYSDATE + DBMS_RANDOM.VALUE(1, 365)), -- generate random end_date between today and 365 days from now
            ROUND(DBMS_RANDOM.VALUE(5000, 15000), 2)); -- generate random bonus between 5000 and 15000 with 2 decimal places
  END LOOP;
  COMMIT;
END;
/

-- Generate Sample Data
BEGIN
  generate_employees_salary(10); -- generate 10 random records
END;

-- Cleanup 
drop table employees;
drop table employees_salary;
drop procedure generate_employees_salary;
