🏗️ Architecture Overview
We use a Hub-and-Spoke model where one AWS account acts as the central hub for our shared domain and resources.

1. IAM Cross-Account Module (./modules/iam-cross-account)
Purpose: Creates a shared administrative role (Feature-C25T4-150-shared-admin-role).

Security: Uses a Trust Policy to restrict access solely to the 12-digit AWS Account IDs of verified teammates.

Permissions: Attaches AdministratorAccess to allow teammates to deploy ALBs, ASGs, and RDS instances within this account.

2. Route 53 Module (./modules/route53)
Purpose: Manages the team domain 4everdevopsteam.click.

Logic: Uses a Data Source to look up the existing Public Hosted Zone, ensuring the code remains idempotent and doesn't conflict with the manual domain registration.

Integration: Outputs the hosted_zone_id for use in ACM certificate validation and ALB alias records.

📂 Project Structure
Plaintext
.
├── main.tf            # Root config calling IAM and Route 53 modules
├── variables.tf       # Root input definitions (teammate_ids, domain_name)
├── terraform.tfvars   # Actual values (Git-ignored in production)
├── outputs.tf         # Hero outputs (Switch-Role link & Zone ID)
└── modules/
    ├── iam-cross-account/
    └── route53/
🛠️ How to Use This Code
1. Initialize & Apply
Bash
terraform init
terraform apply
2. Access the Shared Account
Copy the team_switch_role_link from the terminal output. Click it while logged into your own AWS account to instantly assume the admin role in the project account.

3. Verification
Run dig test.4everdevopsteam.click +short to verify that the Route 53 delegation from the external registrar to AWS is fully functional.
