# terraform-3-tier-infra
3 tier aws infra with terraform

## Project setup

1. Download and install terraform in your machine

2. Clone the repo

3. Get inside the project folder

4. Execute below commands
```
terraform init
terrraform validate
terraform plan
terraform apply
```


- in this project, we create a vpc module which contains the vpc.tf and the variables.tf
- we create a locals.tf file which holds the tags for internal configuration. this locals file can be used in all to adding tags to all resources created for this project.
- we also define sets of variables in the variables.tf file and call them in the vpc.tf file to avoid hardcoding. 
- we created a variable in the variables file but haven't included a value to the tags. when we call this tags in the project we merge it with the tags in the locals file. first, we call the locals file in main.tf by specifying it as tags and what ever tags we have on the tags property of the resource will be overriden. this
- with the merge function, we call the tags variable from the variables.tf file and merge it with selected attributes in the tags property as defined in the locals.tf file. 