# Deploying with terraform

Deploy GCP resources locally using terraform.

## Prerequisites

- Install Terraform

  - On MacOS, run the following in command line:
  - Install the HashiCorp tap

    ```
    brew tap hashicorp/tap
    ```

  - Install Terraform with hashicorp/tap/terraform

    ```
    brew install hashicorp/tap/terraform
    ```

- Create `service-account-key.json` in the deploy directory. This is the key file of your GCP service account.
- Create terraform workspaces `test` and `prod`

  ```
  terraform workspace new test
  terraform workspace new prod
  ```

- Create `terraform.tfvars` file containing environment variables
- Initialize terraform by running
  ```
  terraform init
  ```

## Deploy test-environment resources

- Select test workspace
  ```
  terraform workspace select test
  ```
- Deploy
  ```
  > terraform fmt
  > terraform validate
  > terraform plan
  > terraform apply
  ```

## Deploy production-environment resources

- Select prod workspace
  ```
  terraform workspace select prod
  ```
- Deploy
  ```
  > terraform fmt
  > terraform validate
  > terraform plan
  > terraform apply
  ```
