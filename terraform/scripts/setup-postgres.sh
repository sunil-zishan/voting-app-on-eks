#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io docker-compose
docker run -d --name db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=votingapp \
  -p 5432:5432 postgres
