#!/bin/bash
sudo yum install python -y
sudo yum install python-pip -y
sudo pip install ansible
ansible-playbook pipelines/ansible-pipeline/playbook.yml
