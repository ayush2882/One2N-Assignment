#!/bin/bash
yum update -y
yum install -y python3 git python3-pip
pip3 install flask boto3
git clone https://github.com/ayush2882/One2N-Assignment.git
cd One2N-Assignment
python3 app.py &