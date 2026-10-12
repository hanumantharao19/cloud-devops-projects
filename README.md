# cloud-devops-projects
cloud-devops-projects
# AWS Console and GitHub Setup

Complete the following steps before running the Terraform workflow. The Terraform configuration and GitHub Actions workflow are already available in this repository.

## 1. AWS Console Setup

### Step 1: Create an S3 Bucket for Terraform State

1. Sign in to the [AWS Console](https://console.aws.amazon.com/).
2. Open **S3 → Create bucket**.
3. Enter a globally unique bucket name, for example, `student-terraform-state-12345`.
4. Select your AWS region, such as `us-east-1`.
5. Keep **Block all public access** enabled.
6. Enable bucket versioning.
7. Create the bucket.
8. Open the repository's `01-vpc-project/backend.tf` and update the bucket name, region, and state key according to your bucket and configuration.

**Important:** Each student must use their own S3 bucket and a separate state key. Do not use another student's state bucket.

### Step 2: Configure GitHub OIDC in AWS

OIDC allows GitHub Actions to access AWS without storing long-lived AWS access keys.

1. Open **AWS Console → IAM → Identity providers**.
2. Check whether the GitHub OIDC provider already exists.
3. If it does not exist, select **Add provider**.
4. Select **OpenID Connect**.
5. Enter the provider URL:

   `https://token.actions.githubusercontent.com`

6. Set the audience to:

   `sts.amazonaws.com`

7. Add the provider.

If the provider already exists in your AWS account, reuse it instead of creating a duplicate.

### Step 3: Create an IAM Role for GitHub Actions

1. Open **IAM → Roles → Create role**.
2. Select **Web identity** as the trusted entity type.
3. Select the GitHub OIDC identity provider.
4. Choose `sts.amazonaws.com` as the audience.
5. Configure the role's trust policy to allow only your GitHub repository and the intended branch, such as `main`.
6. Create the role with a meaningful name, for example, `github-actions-terraform`.
7. Copy the role's ARN for the next step.

The repository condition should follow this pattern:

`repo:YOUR_GITHUB_USERNAME/YOUR_REPOSITORY:ref:refs/heads/main`

Replace the placeholders with your actual GitHub username or organization and repository name. Make sure the trust policy matches the OIDC subject issued for your workflow.

### Step 4: Configure IAM Permissions

Attach an IAM permissions policy that allows Terraform to manage only the AWS resources required by the project.

The policy may need permissions for VPCs, subnets, route tables, internet gateways, security groups, and other resources defined in the Terraform configuration. It also needs the appropriate permissions to access the S3 state bucket.

Avoid granting unrestricted administrator access. Review the Terraform resources and backend configuration before deciding which permissions are required.

## 2. GitHub Repository Setup

### Step 5: Add the AWS Role ARN

1. Open your GitHub repository.
2. Navigate to **Settings → Secrets and variables → Actions → Variables**.
3. Select **New repository variable**.
4. Enter the following:

   - **Name:** `AWS_ROLE_ARN`
   - **Value:** Your AWS IAM role ARN

5. Save the variable.

Example ARN format:

`arn:aws:iam::123456789012:role/github-actions-terraform`

Use your own AWS account ID and role name.

### Step 6: Verify the Repository Configuration

Before executing the workflow, verify the following:

- The S3 bucket name in `backend.tf` is correct.
- The backend region and state key are correct.
- The IAM role trusts your GitHub repository and intended branch.
- The IAM permissions allow the required Terraform operations.
- The GitHub repository variable `AWS_ROLE_ARN` contains the correct role ARN.
- The workflow file exists under `.github/workflows/`.

Commit and push any configuration changes to your GitHub repository.

## 3. Run the GitHub Actions Workflow

1. Open your GitHub repository.
2. Select **Actions**.
3. Open the VPC Terraform workflow.
4. Select **Run workflow**.
5. Choose the required action and branch.
6. Run the workflow and review the execution logs.

Available actions:

- **plan:** Preview the infrastructure changes.
- **apply:** Create or update the infrastructure.
- **destroy:** Remove the infrastructure managed by Terraform.

Run `plan` first and review the output before running `apply`. Use `destroy` only when you intend to remove the lab infrastructure.

## 4. Cleanup and Security

- Run `destroy` after completing the lab and verify that the VPC resources have been removed.
- The S3 bucket used for Terraform state can be retained for future labs.
- Do not delete the state bucket while Terraform still needs its state.
- Never commit AWS credentials, sensitive information, or Terraform state files to GitHub.
- Review AWS billing and remove any unused resources.

**Warning:** Terraform `destroy` can permanently delete infrastructure. Always verify the AWS account, repository, and Terraform state before executing it.
