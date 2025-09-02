# 🗳️ Voting App on Amazon EKS

![CI/CD](https://github.com/sunil-zishan/voting-app-on-eks/actions/workflows/ci-cd.yml/badge.svg?branch=main)

A production-grade deployment of a 3-tier voting application on Amazon EKS using Kubernetes, Docker, and GitHub Actions.

---

## 📦 Project Overview

This project demonstrates how to:
- Containerize and deploy microservices (`vote`, `result`, `worker`)
- Set up Redis and Postgres as backend services
- Automate deployments with a CI/CD pipeline
- Route traffic using NGINX Ingress Controller
- Secure sensitive data using Kubernetes Secrets

---

## 🧱 Architecture

- **Frontend:** `vote` app (Python Flask)
- **Backend:** `result` app (Node.js), `worker` (C#/.NET)
- **Data Layer:** Redis (queue), Postgres (persistent storage)
- **Orchestration:** Kubernetes on AWS EKS
- **Ingress:** NGINX Ingress Controller with DNS routing

---

## ⚙️ CI/CD Pipeline

- Triggered on push to `main` or manually via dispatch
- Builds Docker images and pushes to Docker Hub
- Updates image tags in manifests using Git SHA
- Applies Kubernetes manifests to EKS cluster

---

## 🌐 Live URLs

- [Vote App](http://vote.sunilzishan.com)
- [Result App](http://result.sunilzishan.com)

---

## 🧠 Challenges Faced

- Cert-manager CRDs missing → blocked pipeline
- Ingress misrouting → fixed path mappings
- Docker image naming mismatch → corrected tags
- AWS region and cluster name errors → updated to `ca-west-1`

---

## ⚡️ Add-ons & Enhancements

- CI/CD badge in README
- Recursive manifest deployment (`kubectl apply -R`)
- Secrets stored securely via Kubernetes
- Dynamic image tagging with `sed`
- Organized manifest structure by component

---

## 🚀 How to Deploy

```bash
git add .
git commit -m "Deploy updated manifests"
git push origin main
