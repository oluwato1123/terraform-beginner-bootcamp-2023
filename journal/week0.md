# Terraform Beginner Bootcamp 2023 - week 0

- [Semantic Versioning :mage:](#semantic-versioning-mage)
- [Install the Terraform CLI](#install-the-terraform-cli)
   * [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
   * [Coniderations for Linux Distribution](#coniderations-for-linux-distribution)
   * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
      + [Shebang Considerations](#shebang-considerations)
      + [Execution Considerations](#execution-considerations)
      + [Linux Permision Consideration](#linux-permision-consideration)
- [Gitpod lifecycle - Before, Init, Command](#gitpod-lifecycle-before-init-command)
- [Working with Env Vars](#working-with-env-vars)
   * [env command](#env-command)
   * [Printing Vars](#printing-vars)
   * [Scoping of env Vars](#scoping-of-env-vars)
   * [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
   * [Terraform Registry](#terraform-registry)
   * [Terraform Console](#terraform-console)
      + [Terraform Init](#terraform-init)
      + [Terraform Plan](#terraform-plan)
      + [Terraform Apply](#terraform-apply)
      + [Terraform Destroy](#terraform-destroy)
      + [Terraform Lock Files](#terraform-lock-files)
      + [Terraform State Files](#terraform-state-files)
      + [Terraform Directory](#terraform-directory)
- [Issues with Terraform Cloud Login and Gitpod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)
- 
## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging
[semver.org](https://semver.org/).

The general format:

**MAJOR.MINOR.PATCH**, eg: `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes


## Install the Terraform CLI

### Considerations with the Terraform CLI changes

The Terraform CLI installation instructions have changed due to gpg keyring changes, so we needed to refer to the latest CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Coniderations for Linux Distribution

This project is built on Ubuntu.
Please consider checking to see your Linux Distribution and hage accordingly to your distribution needs.

[How to Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

```
 $ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
``````

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprecation issues, we notice that bash scripts steps were a considerable amount of more codes. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](.bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This will allow us an easier time to debug and execute manually Terraform CLI install.
- This will allow better portability for other projects that need to install terraform CLI

#### Shebang Considerations

A shebang (pronounced sha-bang) tells the bash scrippt what program that will interpret the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr.bin/env bash`

- For portability
- Will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in `.gitpod.yml`, we neded to point to a program to interpret it.

eg. `source .bin/install_terraform_cli`

#### Linux Permision Consideration

In order to make our bash script executable, we need to change the linux permission for the file to executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```
alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

## Gitpod lifecycle - Before, Init, Command

We need to be careful when using `init` because it will not rerun if we restart an existing workspace. Use `before` instead.

https://www.gitpod.io/docs/configure/workspaces/tasks



## Working with Env Vars

### env command

We can list out all Environment Variablles (Env Vars) using the `env` command

We can filter specific env vars using grep eg. `env |grep AWS_`

In the terminal we can set using `export HELLO='world'`

In the terminal we can unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO = 'world' ./bin/print_message
```
Within a bash script we can set env without using export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

### Scoping of env Vars

When you open up new bash terminals in VSCode, it will not be aware of env vars that you have set in another window.

If you want env vars to persist across all future bash terminals that are open, you need to set env vars in your bash profile. eg. `.bash_profile`

### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Sececrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.

## AWS CLI Installation

AWS CLI is installed for the project visa the bash script [`.bin/install_aws_cli`](./bin/install_aws_cli)

[Getting started installing AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI env vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credetials is configured correctly  by running the following AWS CLI command:
```sh
aws sts get-caller-identity
```

if it is successful, you should see a json payload that looks like this

```json
{
    "UserId": "AWJAISHACJKFP7TYTRA7GEP5",
    "Account": "0123456789101",
    "Arn": "arn:aws:iam::0123456789101:user/gitpod"
}
```

We'll need to generate AWS CLI Credentials from IAM User in order to use the AWS CLI

Also make sure you remove `awscliv2.zip` and `AWS` when writing the bash scipt under `install_aws_cli`, just like below:

```sh
rm -f '/workspace/awscliv2.zip'
rm -rf '/workspace/aws'
```


## Terraform Basics

### Terraform Registry

Terraform sources their provider and modules from the Terraform registry which is located at [https://registry.terraform.io/](https://registry.terraform.io/)

- **Providers** refers to a plugin that enables Terraform to interact with and manage resources in a specific infrastructure or service. Providers serve as the interface between Terraform and the API or services of a particular cloud provider, on-premises infrastructure, or software service.

[https://registry.terraform.io/providers/hashicorp/random](https://registry.terraform.io/providers/hashicorp/random)



- **Modules** is a way to organize and encapsulate a set of related resources, making it easier to manage and reuse configurations. Modules enable you to break down your infrastructure code into smaller, more manageable and reusable components.

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`

#### Terraform Init

`terraform init` is a command used in Terraform to initialize a new or existing Terraform configuration in a directory. When you run `terraform init`, Terraform performs the initialization steps.

#### Terraform Plan

`terraform plan` is a command in Terraform that analyzes your configured infrastructure and provides a preview of the changes that would be made if you were to apply your configuration using `terraform apply`. It's a critical step in the Terraform workflow as it helps you understand the intended changes and potential impacts on your infrastructure before actually applying them. 

#### Terraform Apply

`terraform apply` is a command in Terraform used to apply the changes described in your Terraform configuration to the targeted infrastructure. It takes the desired state from your configuration and makes the necessary API calls to create, modify, or delete resources in order to align the actual infrastructure with the desired state. Apply should prompt yes or no.

If we want to automitically approve an apply, we can apply the auto approve flag - `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy` is a command in Terraform used to destroy all the resources created by the Terraform configuration in the specified directory. It essentially reverses the actions taken by `terraform apply` by deleting all managed infrastructure.

 If you want to automate the destroy without manual confirmation, you can use the -auto-approve flag eg. `terraform destroy --auto-approve`

#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VSC) eg. Github

#### Terraform State Files

`.terraform.tfstate` contains the information about the current state of your infrastructure.

This file **should not be committed** to your VCS

This file can contain sensitive data

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file

#### Terraform Directory
`.terraform` directory contains binaries of terraform providers.


## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login`, it lauches a bash with a wiswig view to generate a token. It doesn't work as expected in Gitpod VsCode in the browser.

The walkaround is to manually generate a token in Terraform cloud using the link below
```
https://app.terraform.io/app/settings/tokens
```

You paste your token at the `enter value` prompt, you'll probably not see the the token pasted but hit enter regardless and that should work.

