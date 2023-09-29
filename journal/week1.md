# Terraform Beginner Bootcamp 2023 - week 1

## Fixing Tags 

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locally delete a tag

```
git tag -d <tag_name>
```

Remotely delete a tag

```
git push --delete origin tagname
```

Checkout the commit that you want to retag, grab the SHA from the github history 

```sh
git checkout SHA
git tag M.M.P
git push --tags
git checkout main
```

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
![variable precedence](https://github.com/oluwato1123/terraform-beginner-bootcamp-2023/assets/77586531/d1b60172-fb2e-467d-8564-f433c9b22cba)


## Dealing with Configuration Drift


### What happens if you lose your state file?
If you lose your state file, You'll most likely need to tear down all your cloud infrastructure manually. 

You can use `terraform import`, but it won't work for all cloud resources. You need to check the terraform provider documentation to see which resources support import.


### Fix missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resources manually through clickops. If we run `terraform plan`, it will attempt to put our infrastructure back into the expected state fixing configuration drift


### Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```


## Terraform Modules 

### Terraform Module Structure
It is recommended to place module in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variable

We can pass input variables to our modules.
The module has to declare the terraform variables in its own `variables.tf`

```tf
module "terrahouse_aws" {
  source = "./modules/Terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module sources

Using the sources, we can import modules from various places eg:
- locally
- Github
- Terraform Registry 
- BitBucket
- GitLab
- Local relative Path
- Private Git Repositories

```tf
module "terrahouse_aws" {
  source = "./modules/Terrahouse_aws"
}
```

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write terraform
LLMs such as ChatGPT ay not be trained on the latest documentation or information about terraform.

It may likely show older examples that could be deprecated, often affecting providers.


## Working with files in Terraform

### Fileexists Function

This is a built-in terraform function to check the existance of a file in a given path.

Functions are evaluated during configuration parsing rather than at apply time, so this function can only be used with files that are already present on disk before Terraform takes any actions.

```tf
condition     = fileexists(var.error_html_filepath)
```

[fileexists function](https://developer.hashicorp.com/terraform/language/functions/fileexists)


### Filemd5 Function

The filemd5() function in Terraform calculates the MD5 checksum of a file. It takes the path to the file as an argument and returns a string containing the MD5 checksum.

The MD5 checksum is then used to set the etag attribute of the aws_s3_bucket_object resource. This ensures that the file will not be overwritten if it has not been changed

[filemd5 Function](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

In terraform, there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for a current module
- path.root = get the path for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

example - 

```
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source ="${path.root}/public/index.html"

  etag = filemd5(var.index_html_filepath)
}
```
