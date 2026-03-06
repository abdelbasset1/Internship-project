🛡️ IAM Cross-Account Access Module
Feature Branch: feature/C25T4-150-cross-account-iam-role

Engineer: Ben

Account Owner: BB (7005-8065-0379)

📋 Overview
This module automates the creation of a centralized administrative role within the shared AWS account. It allows specified team members to "Switch Role" from their personal accounts into the project environment with full AdministratorAccess.

🛠️ Technical Implementation
1. Manual Setup (Immediate Unblock)
To ensure zero downtime for the team, the role was manually provisioned with the following parameters:

Role Name: Feature-C25T4-150-shared-admin-role

Policy: arn:aws:iam::aws:policy/AdministratorAccess

Trust Relationship: Configured for 7 authorized Account IDs.

2. Terraform Automation
The infrastructure is now managed as code to ensure consistency and prevent manual drift.

Modular Design: Located in modules/iam-cross-account/ for reusability.

Dynamic Trust Policy: Uses a jsonencode block to dynamically generate the Principal list from a variable.

Provider-Free: The module inherits the AWS provider from the project root to maintain consistency.

3. Repository Hygiene
To maintain a clean and performant repository, a .gitignore was implemented to exclude:

Heavy Binaries: Excluded the .terraform/ folder (approx. 730MB of provider plugins).

State Files: Excluded *.tfstate to prevent merge conflicts and state corruption.

Local Vars: Excluded local sensitive configurations.

🚀 How to Use (For Teammates)
To access the shared environment, follow these steps:

Prerequisite: Log into your IAM User (not Root) in your personal AWS account.

Action: Navigate to the top-right menu and select Switch Role.

Details:

Account: 700580650379

Role: Feature-C25T4-150-shared-admin-role

Display Name: SHARED-ACC

📈 Billing & Cost Control
As the Account Owner, I am monitoring costs via:

Billing Alarms: Configured in us-east-1 for early warning.

AWS Budgets: Set to alert the team if the monthly forecast exceeds $5.00.

Current Forecast: $18.72 (as of March 2). Please ensure all expensive resources (NAT Gateways/RDS) are destroyed at the end of each session.
