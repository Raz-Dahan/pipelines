#!/bin/bash
sudo yum install python -y
sudo yum install python-pip -y
sudo pip install ansible
ansible-playbook pipelines/flask-ansible/playbook.yml
