# Cloud-Server-Monitoring
This repo is about provisioning AWS EC2 Ubuntu server and related services and monitoring it using Promethius and  Grafana while testing the load using Apache Jmeter

## Architecture Diagram



<img width="721" height="681" alt="Monitoring diagram" src="https://github.com/user-attachments/assets/0ae4b484-735b-4c19-8131-8534c2ca6744" />


# Steps
## 1.Provision the infrastructure in AWS as shown in the diagram
I configured Moodle open-source application inside this EC2. It's not necessary to configure that. If you don't need to configure that, you will not need RDS to provision.
## 2. Configure Prometheus and Node exporter

Download the 'PrometheusNodeExporter' script file and move it to the EC2 server and run it.

In security group that attached to EC2,
  Allow 9090 port for Prometheus
  
  Allow 9100 port for Node Exporter

## 3. Install Grafana
Download Grafana.sh script and move it to the EC2 and run it.

Check the status of Grafana using, "sudo systemctl status grafana-server" command

In security group that attached to EC2,
  Allow 3000 port for Grafana

Open the Browser and run,
http://<"EC2-Public-IP">:3000

Default credentials:
  username: admin
  
  password: admin (you’ll be asked to set a new password)

## 4. Add Prometheus as a Data Source

Login to Grafana (http://<"EC2-Public-IP">:3000)

Go to Configuration → Data Sources → Add data source

Select Prometheus

In the URL, enter:
  http://localhost:9090
  
Click Save & Test

## 5. Import Node Exporter Dashboard

Grafana has prebuilt dashboards for Node Exporter.

In Grafana → left menu → Dashboards → Import

Enter this dashboard ID: 1860 (popular Node Exporter Full) Or use official ones: 13978 / 14513

Select your Prometheus data source and import.

You’ll now see CPU, memory, disk, network, and more stats from your EC2 in a nice dashboard 🚀

## 6. Setup Grafana with reverse proxy in Apache2 for secure login
### After setting up, you will be able to loging Grafana with using "http://yourdomain.com/grafana"

### 6.1 Enable Apache Proxy Modules
Run below commands,

```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod headers
sudo a2enmod rewrite
sudo a2enmod ssl
```

Then Restart Apche using -> ```sudo systemctl restart apache2```

### 6.2 Create Apache Virtual Host for Grafana
### If you don't have a conf file inside "/etc/apache2/sites-available"   
Then create a conf file using sudo nano /etc/apache2/sites-available/grafana.conf  
Add all the content of grafana.conf file.

### IF you already have a conf file in this location -> "/etc/apache2/sites-available",  
Then add below line to that conf file between "VritualHost" tags.

```bash
  # -------- Grafana Proxy --------
ProxyPreserveHost On
ProxyRequests Off

ProxyPass /grafana http://localhost:3000/grafana
ProxyPassReverse /grafana http://localhost:3000/grafana

<Location /grafana/>
    Require all granted
    ProxyPassReverseCookiePath / /grafana
</Location>
```
Save & Exit.

### 6.3 Adjust Grafana Config (important for reverse proxy)
Edite Grafana Config:  
```bash
sudo nano /etc/grafana/grafana.ini
```
### Find and change belwo lines:  
[server]  
protocol = http  
http_addr =  
http_port = 3000  
domain = YourDomain.com  
root_url = https://YourDomain.com/grafana  
serve_from_sub_path = true  

## Note: If there is a ";" infront of above lines, please remove that ";" from above lines only!


### 6.4 Restart services
```bash
sudo systemctl restart grafana-server
sudo systemctl reload apache2
```

## Now you can access to Grafana useing "https://yourdomain.com/grafana"  
### This will give you a way to access Grafana without using public IP Address.

## 7. configure Apche Jmeter for load testing
Prerequisites-> Java must be installed on your machine (JDK 8 or higher).  
you can check if java is installed by running  
```bash
java --version
```
Download the zip file using this link "https://jmeter.apache.org/download_jmeter.cgi" and extract the zip folder into your program files in C drive.  
To Run JMeter (GUI mode)  
On Windows:  
Navigate to the extracted JMeter folder.  
Go to the bin folder.  
Double-click on jmeter.bat (Or right-click → Open with Command Prompt)  

✅ After Launching JMeter You’ll see the Apache JMeter GUI.  
From there you can:  
Create a Test Plan  
Add a Thread Group  
Add HTTP Request Samplers  
Add Listeners to view the results  
Click Start (Green triangle) to run the test  

While testing, you can watch the Grafana dashboard to monitor the EC2 server.

## Summary Report of Load testing using Jmeter  

<img width="1513" height="838" alt="Screenshot (262)" src="https://github.com/user-attachments/assets/58ade8b4-f45f-4c78-917e-b18b9fd9cba5" />

## Snaps of Grafana Dashboard for Node Exporter

<img width="1900" height="904" alt="Screenshot (262)copy" src="https://github.com/user-attachments/assets/8c03b561-cf5f-4222-8ba1-47f2ded4a2f8" />

<img width="1920" height="973" alt="Screenshot (261)" src="https://github.com/user-attachments/assets/3dd979fe-4e9c-4fd3-9812-e9ba7a163031" />

