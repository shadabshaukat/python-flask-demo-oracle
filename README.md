# Oracle Flask Demo 
A Demo App build with Python3, Flask Package and Oracle Autonomous Database

The python-flask-demo-oracle repository contains a simple Flask application that demonstrates how to connect to an Oracle Autonomous database (or any other Oracle Database) and perform basic CRUD (Create, Read, Update, Delete) operations on a database table.

The application consists of a single Flask app defined in the main.py file, which serves as the entry point for the application. The main.py file defines several Flask routes (i.e. URL endpoints) that handle HTTP requests from clients and return HTTP responses.

The main features of the application are:

    Database connection: The app connects to an Oracle database using the python-oracldb library and a DSN (Data Source Name) string that specifies the hostname, port, service name, username, and password for the database connection.

    CRUD operations: The app allows users to perform basic CRUD operations on a database table called employees. Users can add new employees, view all employees, update employee information, and delete employees.

    SSL/TLS encryption: The app uses SSL/TLS encryption to secure HTTP traffic between the client and server. You can use self-signed SSL certificates, and the Flask app is configured to use this certificate to encrypt HTTP traffic.

The repository also contains several HTML templates that define the app's user interface. The base.html template defines the basic layout of the app, while the other templates extend this base template and define the content for specific pages (e.g. the add employee form, the view employees page, etc.).


## Quick Build & Deploy with Docker or Podman
#### 1. Clone the Repo

```
git clone https://github.com/shadabshaukat/python-flask-demo-oracle.git

cd python-flask-demo-oracle/
```

#### 2. Generate the self-signed certificates

```
openssl genrsa -out key.pem 2048

openssl req -new -x509 -newkey rsa:2048 -key key.pem -out cert.pem

chmod +r cert.pem key.pem
```
  
#### 3. Check for certificate and key file

```
ls -ltr
```

#### 4. Replace username,password & connection string in main.py with your Autonomous DB details
```
vim main.py
```

#### 5. Create table in Autonomous DB

```
CREATE TABLE employees (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    department VARCHAR2(255) NOT NULL
);
```

#### 6. Enable port 4443 on local machine where you are running Docker (Linux only)
```
sudo firewall-cmd --permanent --add-port=4443/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --zone=public --permanent --list-ports
```

#### 7. Build the Docker Image

```
docker build -t oracleflaskdemo .
```

#### 8. Run the Docker Container

```
docker run -p 4443:4443 oracleflaskdemo
```

#### Note : If you are using Podman instead of Docker, just replaced 'docker' with 'podman' in the commands
```
# Install Podman on MacOS M1 Pro
brew install podman
podman machine init
podman machine set -m 3072
podman machine start

# Build Flask App
podman build -t oracleflaskdemo .
podman run -p 4443:4443 oracleflaskdemo
```

## Test APIs with HTML Form and Report

#### Open in browser

```
https://127.0.0.1:4443/api/main
```

#### Enter API Username & Password
```
Username : user1
Password : password1
```

<img width="428" alt="Screen Shot 2023-03-11 at 11 22 25 pm" src="https://user-images.githubusercontent.com/39692236/224484216-72b14f5c-6607-4d23-8d85-8992984956bd.png">

<img width="1439" alt="Screen Shot 2023-03-11 at 11 20 40 pm" src="https://user-images.githubusercontent.com/39692236/224484111-2986bfd0-a731-4d51-8649-fabf96fa5bd1.png">



## Oracle Linux VM Deploy 

### 1. Install Python 3.6, flask , cx_Oracle, Jinga2 & six packages on Oracle Linux 7

First pre-requisite is to ensure your instance has Python3 installed along with the Python packages. We will also install the command-line browser links to test the API using a html form.

```
  sudo yum install python36
  sudo yum install links
  sudo yum install openssl

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
openssl genrsa -out key.pem 2048

openssl req -new -x509 -newkey rsa:2048 -key key.pem -out cert.pem

chmod +r cert.pem key.pem

sudo firewall-cmd --permanent --add-port=4443/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --zone=public --permanent --list-ports
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
    app.run(host='0.0.0.0', port=4443, ssl_context=('cert.pem', 'key.pem'))
```

### 7. Run the Python script

```
$ python3 main.py 
         * Running on https://10.180.1.21:4443/ (Press CTRL+C to quit)
 ```


