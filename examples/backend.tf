terraform {
  backend "gcs" {
    bucket = "simon-tf-state-cicd-dev"
    prefix = "terraform/state/dev"
  }
}