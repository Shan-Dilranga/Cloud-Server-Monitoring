# Cloud-Server-Monitoring
This repo is about provisioning AWS EC2 server and related services and monitoring it using Promethius and  Grafana while testing the load using Apache Jmeter

## Architecture Diagram



<img width="721" height="681" alt="Monitoring diagram" src="https://github.com/user-attachments/assets/0ae4b484-735b-4c19-8131-8534c2ca6744" />


# Steps
## 1.Provision the infrastructure in AWS as shown in the diagram
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
http://<EC2-Public-IP>:3000

Default credentials:
username: admin
password: admin (you’ll be asked to set a new password)

## 4. Add Prometheus as a Data Source

Login to Grafana (http://<EC2-Public-IP>:3000)
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
