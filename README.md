# Python Flask Demo Oracle
A Demo App build with Python3, Flask Package and Oracle Autonomous Database

## Deploy

### 1. Install Python 3.6, flask , cx_Oracle, Jinga2 & six packages on Oracle Linux 7

First pre-requisite is to ensure your instance has Python3 installed along with the Python packages. We will also install the command-line browser links to test the API using a html form.

```
  sudo yum install python36
  sudo yum install links
  sudo pip3 install flask
  sudo pip3 install flask_cors
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

### 3. Deploy the Oracle Table

The example uses a simple table called employees in the hr schema. An identity column is used to auto-increment the id of the employee

```
CREATE TABLE employees (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    department VARCHAR2(255) NOT NULL
);
```

### 4. Clone the Repo & Install Python Packages 

```
git clone https://github.com/shadabshaukat/python-flask-demo-oracle.git

cd python-flask-demo-oracle/

pip3 install -r requirements.txt

```



### 5. Change path for template_folder in main.py to reflect the local directory where .html files and code is stored :


```
app = Flask(__name__, template_folder='<your local directory>')
```

This will allow two web pages one for the POST request to the “/api/add_employee” endpoint and another for getting a list of all employees in the databases via "/api/getall"

### 6. Change path for SSL certificates in main.py file to location of SSL certificates created in Step 2.

```
    app.run(host='0.0.0.0', port=4443, ssl_context=('/home/opc/ssl-certs/cert.pem', '/home/opc/ssl-certs/key.pem'))
```

### 7. Run the Python script

```
$ python3 main.py 
         * Running on https://10.180.1.21:4443/ (Press CTRL+C to quit)
 ```


## Test APIs with curl


```
# Get report of all employees 
 curl https://10.180.1.21:4443/api/employees -k
```

```
# Add a new employee
 curl -X POST https://10.180.1.21:4443/api/employees -d '{"name":"Shadab M","email":"shadabm@example.com","department":"IT"}' -H "Content-Type: application/json" -k
```

```
# Get employee details of a particular employee using id 
 curl https://10.180.1.21:4443/api/employees/1 -k
```

```
# Update employee details using id
 curl -X PUT https://10.180.1.21:4443/api/employees/1 -d '{"name":"Michael","email":"michael@example.com","department":"IT"}' -H "Content-Type: application/json" -k
```
```
curl https://10.180.1.21:4443/api/employees/1 -k
```

```
# Delete employee using id
 curl -X DELETE https://10.180.1.21:4443/api/employees/1 -k
 curl https://10.180.1.21:4443/api/employees/1 -k
```

```
# Search employee by email
 curl https://10.180.1.21:4443/api/employees/search/shadabm@example.com -k
```

## Test APIs with HTML Form and Report

```
https://10.180.1.21:4443/api/add_employee
```

```
username : user1
password : password1
```


<img width="392" alt="Screen Shot 2023-03-10 at 7 23 20 pm" src="https://user-images.githubusercontent.com/39692236/224262717-304c76f6-8d9e-414d-9b31-f2827832ffb9.png">


<img width="1565" alt="Screen Shot 2023-03-10 at 5 41 47 pm" src="https://user-images.githubusercontent.com/39692236/224250317-964f7b22-9fae-4a76-a857-ab5187f92846.png">



### Test Get All Employees with HTML


```
https://10.180.1.21:4443/api/getall
```

```
username : user2
password : password2
```

<img width="396" alt="Screen Shot 2023-03-10 at 7 22 49 pm" src="https://user-images.githubusercontent.com/39692236/224262583-0fe55a7f-5867-4adc-a493-5370e862f5bd.png">

<img width="1537" alt="Screen Shot 2023-03-10 at 5 42 05 pm" src="https://user-images.githubusercontent.com/39692236/224250341-cb14719b-dd39-4cd8-b91c-ad04214007e3.png">

## Functions & APIs

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

