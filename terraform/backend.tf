terraform {
  backend "s3" {
    bucket         = "sunil-terraform-state-dvft2025"
    key            = "infra/sunil-vote-app.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
