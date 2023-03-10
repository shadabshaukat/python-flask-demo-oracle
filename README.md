# python-flask-demo-oracle
A Demo App build with Python3, Flask Package and Oracle Autonomous Database

## Deploy

### 1. Install Python 3 and the flask , cx_Oracle, Jinga2 & six packages on Oracle Linux 7

First pre-requisite is to ensure your instance has Python3 installed along with the Python packages. We will also install the command-line browser links to test the API using a html form.

```
  sudo yum install python36
  sudo yum install links
  sudo pip3 install flask
  sudo pip3 install six
  sudo pip3 install Jinja2
  sudo pip3 install oracledb
```

```
  python3 --version
```

### 2. Generate Self-signed certificates and firewall rules

As we are creating a secure web server ensure you need SSL certificates. In this example for demo purposes we are creating self-signed certificates but in a production scenario you should have SSL certificates issued from a third party authority.

```
sudo yum install openssl

mkdir ~/ssl-certs

openssl genpkey -algorithm RSA -out ~/ssl-certs/key.pem

openssl req -new -x509 -key ~/ssl-certs/key.pem -out ~/ssl-certs/cert.pem

chmod +r cert.pem key.pem

sudo firewall-cmd --permanent --add-port=4443/tcp
```

### 3. Deploy the Oracle Table, Sequence and Trigger

The example uses a simple table called employees in the hr schema. An identity column is used to auto-increment the id of the employee

```
CREATE TABLE employees (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    department VARCHAR2(255) NOT NULL
);
```

### 4. Main Python code

This is the core python3 code to create a web server with Flask and add the routes for the API’s on the employees table in Oracle.

There are 6 functions in the script, each performing a REST call for GET, PUT, POST and DELETE operations. I’ve included an additional function to add an employee using html form via render_template

```
GET ALL - def get_employees(): 
/* Fetches all the employees from Oracle table eg :  curl https://10.180.1.21:4443/api/employees -k */

GET EMP - def get_employee(id):
/* Fetches a single employee using the id and throws error 404 if employee not found eg : curl https://10.180.1.21:4443/api/employees/1 -k */

ADD EMP - def add_employee():
/* Adds an employee to the Oracle table and throws error if the same email already exists eg :  curl -X POST https://10.180.1.21:4443/api/employees -d '{"name":"Shadab M","email":"shadabm@example.com","department":"IT"}' -H "Content-Type: application/json" -k */

UPDATE EMP - def update_employee(id):
/* Updates an employee details but throws 404 error if employee id does not exist eg : curl -X PUT https://10.180.1.21:4443/api/employees/1 -d '{"name":"Michael","email":"michaelm@example.com","department":"IT"}' -H "Content-Type: application/json" -k */

DELETE EMP - def delete_employee(id):
/* Deletes an employee but throws 404 error if employee not found */ 

GET EMP BY EMAIL - def search_employee(email):
/* Search an employee by their email address, if employee email is not found it returns 404 error eg :curl https://10.180.1.21:4443/api/employees/search/shadabm@example.com -k */ 

ADD EMP USING HTML FORM - def add_employee_form():
/* Add an employee using an html form with the Jinga2 flask render_template. The render_template function is used to render an HTML template called "add_employee.html" that contains the form. */
```

### 5. Create a HTML file in location

The html file should be created in location for eg:

```
app = Flask(__name__, template_folder='/home/opc')
```

This will send the POST request to the “/api/add_employee” endpoint using function add_employee_form(). Save this file with name ’add_employee.html’

vim /home/opc/add_employee.html

```
<form action="/api/add_employee" method="post">
  <div class="form-group">
    <label for="name">Name:</label>
    <input type="text" class="form-control" id="name" name="name" required>
  </div>
  <div class="form-group">
    <label for="email">Email:</label>
    <input type="email" class="form-control" id="email" name="email" required>
  </div>
  <div class="form-group">
    <label for="department">Department:</label>
    <input type="text" class="form-control" id="department" name="department" required>
  </div>
  <button type="submit" class="btn btn-primary">Add Employee</button>
</form>
```

## Test

Run the Python script and Test the API’s using curl

```
$ python3 ~/oracle_flask_v3.py 
         * Running on https://10.180.1.21:4443/ (Press CTRL+C to quit)
 
# Get report of all employees 
 curl https://10.180.1.21:4443/api/employees -k

# Add a new employee
 curl -X POST https://10.180.1.21:4443/api/employees -d '{"name":"Shadab M","email":"shadabm@example.com","department":"IT"}' -H "Content-Type: application/json" -k
 
# Get employee details of a particular employee using id 
 curl https://10.180.1.21:4443/api/employees/1 -k

# Update employee details using id
 curl -X PUT https://10.180.1.21:4443/api/employees/1 -d '{"name":"Michael","email":"michael@example.com","department":"IT"}' -H "Content-Type: application/json" -k
 curl https://10.180.1.21:4443/api/employees/1 -k

# Delete employee using id
 curl -X DELETE https://10.180.1.21:4443/api/employees/1 -k
 curl https://10.180.1.21:4443/api/employees/1 -k

# Search employee by email
 curl https://10.180.1.21:4443/api/employees/search/shadabm@example.com -k
```

Test Add Employee API using a HTML form

```
links https://10.180.1.21:4443/api/add_employee
```
