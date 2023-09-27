# Terraform Beginner Bootcamp 2023 - week 1

## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
│
├── main.tf                    # This file contains the main configuration for your infrastructure resources.
├── variables.tf               # Define input variables that will be used throughout your configuration.
├── terraform.tfvars           # This file is used to set variable values. It should not be committed to version control to avoid exposing sensitive information. 
├── providers.tf               # This file is used to define the providers and their configurations for the Terraform configuration.
├── outputs.tf                 # Define the outputs of the resources you want to expose.
└── README.md                  # This file typically provides an overview of the project, how to use it, any prerequisites, and other relevant information.

```


[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
