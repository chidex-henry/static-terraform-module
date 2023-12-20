# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "henry-terraform-remote-state2"
    key     = "jupiter-website-ecs.tfstate"
    region  = "us-east-1"
    profile = "terraform-user"
  }
}