#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io docker-compose git
git clone https://github.com/sunil-zishan/ironhack-project-1.git
cd ironhack-project-1
docker-compose up -d vote result
