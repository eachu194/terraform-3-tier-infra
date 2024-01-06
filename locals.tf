locals {
  project_tags = {
    Contact      = "devops@jjtech.com"
    Application  = "payments"
    Project      = "jjtech"
    CreationTime = formatdate("EEE DD MMM YYYY hh:mm:ss ZZZ", timestamp())
    Environment  = "${terraform.workspace}"
  }
}