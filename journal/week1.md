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
## Terraform and Input Variables

### Terraform Cloud Variables

In Terraform, we can set two kinds of variables:
- Environment variables - those you would set in your bash terminal eg. AWS credentials
- Terraform variables - those that you would normally set in your tfvars file.

We can set Terraform Cloud variables to be **sensitive** so they are not shown visibly in the UI.

### Loading Terraform Input Variables

[Terraform Input variables](https://developer.hashicorp.com/terraform/language/values/variables)
### var flag

We can use the `-var` flag to set an input variable or override a variable in the **tfvars** file eg. `terrafrom plan -var user_uuid="my_user_id"`

### var-file flag

This flag is used to specify a file containing variable values that you want to use when running Terraform commands like `terraform apply` or `terraform plan`. eg. `terraform plan -var-file="example.tfvars"`

### terraform.tfvars

This is a file used in Terraform to define and set variable values for a Terraform configuration. This file is optional and provides a convenient way to assign values to variables used in the Terraform configuration without specifying them on the command line every time you run Terraform commands.

### auto.tfvars

The `auto.tfvars` file in Terraform is used to automatically load variable values without the need for explicit command-line variable definitions (-var flags). This file provides a way to set variable values conveniently, especially when running Terraform commands, such as `terraform apply` or `terraform plan`.

When running Terraform in Terraform Cloud, it automatically looks for a file named `auto.tfvars` in the working directory of the configuration being applied. If found, it automatically loads the variable values from this file

### Order of terraform variable precedence
