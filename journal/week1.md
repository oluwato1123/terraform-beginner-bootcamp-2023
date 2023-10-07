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

## Terraform Locals

 locals are a way to declare and define variables within a Terraform configuration. Locals allow you to define named values or expressions that can be reused throughout your configuration, making it easier to manage and organize your Terraform code.

```tf
locals {
    s3_origin_id = "MyS3Origin"
}
```

```tf
locals {
  region = "us-west-2"
  instance_type = "t2.micro"
}
```

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform data sources

`data sources` are used to fetch information from external sources and make that information available within your Terraform configuration. Data sources do not create or manage any infrastructure; instead, they allow you to import and use existing information within your configuration.

```ft
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

jsonencode is a function in Terraform used to convert a given Terraform value into its corresponding JSON representation. It takes a Terraform value (such as a map, list, or string) and returns a JSON-encoded string representing that value. This is especially useful when interacting with external systems or APIs that expect data in JSON format.

`jsonencode` was used to create the json policy in line in the hcl

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```
[jsonencode Function](https://developer.hashicorp.com/terraform/language/functions/jsonencode)


## Changing the Lifecycle of resources

The lifecycle meta-argument in Terraform allows you to control the lifecycle behavior of a resource. It provides fine-grained control over actions like creating, updating, and deleting a resource, allowing you to customize how Terraform manages the resource throughout its lifecycle.

Here's an example of how to use the lifecycle meta-argument:

```
resource "example_resource" "example" {
  # Resource configuration

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = ["ignore_me"]
  }
}
```

[The lifecycle Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

```tf
variable "revision" {
  default = 1
}

resource "terraform_data" "replacement" {
  input = var.revision
}

    # This resource has no convenient attribute which forces replacement,
    # but can now be replaced by any change to the revision variable value.
resource "example_database" "test" {
  lifecycle {
    replace_triggered_by = [terraform_data.replacement]
  }
}
```

[Terraform_Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)


## Provisioners

Provisioners are used to execute scripts or commands on a local machine or a remote resource (like an EC2 instance) as part of resource creation or destruction. Provisioners allow you to set up, configure, or perform actions on resources before or after they are created or destroyed.

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionaity exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

The local-exec provisioner in Terraform is a type of provisioner that allows you to execute commands locally on the machine where Terraform is being run. This provisioner is typically used to perform actions on the machine running Terraform, either before or after resource creation or destruction.

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

[Local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote_exec

The remote-exec provisioner in Terraform is a provisioner that allows you to execute commands on a remote resource, such as an AWS EC2 instance, via SSH (for Linux instances) or WinRM (for Windows instances). This provisioner is useful for configuring or initializing the remote resource after it has been created.

You'll need to provide credentials to do this.

[Remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

### Heredoc Strings
  Terraform also supports a "heredoc" style of string literal inspired by Unix shell languages, which allows multi-line strings to be expressed more clearly.

```
<<EOT
hello
world
EOT
```

[Heredoc Strings](https://developer.hashicorp.com/terraform/language/expressions/strings#heredoc-strings)


## For_each expression 

The for_each expression allows you to create multiple instances of a resource or module based on a map or set of strings. It iterates over a collection and creates a separate resource instance for each element in the collection, using the element as a key for identifying the instances.

This is mostly useful when you are creating multiples of cloud resource and you want to redice the amount of repetitive terraform code.

[for_each expression](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)