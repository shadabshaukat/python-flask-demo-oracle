-- Employees Table --
CREATE TABLE employees (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    department VARCHAR2(255) NOT NULL
);

-- Insert 10 records 'employees' table --
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

-- Employees Salary Table --
CREATE TABLE employees_salary (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id NUMBER NOT NULL,
    salary NUMERIC(10, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    bonus FLOAT NOT NULL,
    CONSTRAINT fk_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id)
);

-- Insert 10 records 'employees_salary' --
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (1, 50000, '2022-01-01', '2022-12-31', 10000.0);
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (2, 55000, '2022-01-01', '2022-12-31', 11000.0);
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (3, 60000, '2022-01-01', '2022-12-31', 12000.0);
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (4, 65000, '2022-01-01', '2022-12-31', 13000.0);
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (5, 70000, '2022-01-01', '2022-12-31', 14000.0);
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (6, 50000, '2022-01-01', '2022-12-31', 10000.0);
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (7, 55000, '2022-01-01', '2022-12-31', 11000.0);
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (8, 60000, '2022-01-01', '2022-12-31', 12000.0);
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (9, 65000, '2022-01-01', '2022-12-31', 13000.0);
INSERT INTO employees_salary (employee_id, salary, start_date, end_date, bonus) VALUES (10, 70000, '2022-01-01', '2022-12-31', 14000.0);
commit;
