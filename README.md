Shell Roboshop – Automated Deployment on AWS

This project automates the complete deployment of the Roboshop Microservices Application using Shell Scripts on AWS EC2.

🚀 Overview

All microservices (Cart, Catalogue, User, Payment, Shipping, Frontend) are deployed on Linux EC2 instances using automated shell scripts.
Each component installs its dependencies, configures systemd service files, manages application users, downloads artifacts, and starts the service automatically.

🛠️ Tech Stack

AWS EC2

Linux / Bash Scripting

NodeJS / Python / Maven

MongoDB

Redis

Nginx Reverse Proxy

systemd Services

📂 Features

One-command deployment for each component

Automated package installation & service setup

Database schemas loaded automatically

Nginx configured as reverse proxy

Consistent folder structure for all microservices

Reusable and modular shell scripts

📘 How to Run
sudo bash frontend.sh
sudo bash user.sh
sudo bash cart.sh
sudo bash catalogue.sh
sudo bash payment.sh
sudo bash shipping.sh

✔️ Highlights

Fully automated deployment workflow

Follows best practices for Linux, networking, and service management

Easy to reuse, extend, and integrate with CI/CD later
