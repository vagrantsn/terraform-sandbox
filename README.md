# Terraform Sandbox

This is a sandbox repo I created to practice AWS resources provisioning through Terraform.

## Setup

The projects require an AWS profile named `personal` to be configured, this is done by creating a file at `~/.aws/credentials` with your credentials:

```
[personal]
aws_access_key_id = <access-key>
aws_secret_access_key = <secret-key>
```

Then navigate to your desired project and run `terraform init` before applying the resources.

#### Caution

Provisioning free tier resources is not a guarantee so usage **may be charged**.
