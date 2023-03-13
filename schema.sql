CREATE TABLE employees (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    department VARCHAR2(255) NOT NULL
);

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
