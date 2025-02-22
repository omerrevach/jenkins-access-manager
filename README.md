# Jenkins Secure Access Control Web App

## Overview

This web application provides secure access to a Jenkins instance by leveraging AWS Cognito for authentication and MFA enforcement. It ensures that only pre-approved users can log in, verify their identity using Google Authenticator or Authy, and have their IP dynamically added to an AWS Security Group, allowing them to access the Jenkins UI.

### Features

- ✅ Pre-Approved User Access – Only users manually registered in AWS Cognito can log in
- ✅ Multi-Factor Authentication (MFA) – Users must authenticate via TOTP (Google Authenticator/Authy)
- ✅ Dynamic IP Whitelisting – Upon successful authentication, the user's public IP is added to the Jenkins Security Group, allowing access
- ✅ Temporary Access – Access is only granted for a limited time; users must log in again if their IP changes
- ✅ No Permanent Open Ports – The Jenkins UI remains secured, accessible only to authenticated users.

### Architecture

- User logs in with their Cognito username & password.

- Cognito forces MFA authentication via Google Authenticator/Authy.

- Once authenticated, the app retrieves the user’s public IP.

- AWS Security Group is updated to allow the user’s IP on port 8080.

- User accesses Jenkins UI (http://EC2-PUBLIC-IP:8080).

- IP is automatically removed after a set time (if configured in AWS).

### Prerequisites

1. **AWS Resources (Created via Terraform)**

    - AWS Cognito User Pool with MFA enforcement.

    - Cognito App Client (used for authentication).

    - AWS Security Group for Jenkins access management.


2. **Deploy AWS Cognito with Terraform**
    ```
    terraform init
    terraform apply -auto-approve
    ```

    Copy the output values (cognito_user_pool_id, cognito_client_id).

2. **Add Users to Cognito**
    ```
    ./create_users.sh
    ```


4. **How Users Log In**

- Go to the web app login page.

- Enter username & password (Cognito forces password reset on first login).

- Scan the MFA QR code (Google Authenticator/Authy).

- Enter the MFA code.

- Upon successful authentication, the user’s IP is added to the Jenkins Security Group.

- The user can now access Jenkins UI (http://EC2-PUBLIC-IP:8080).

- Security Considerations

- Only pre-approved users can log in (no self-registration).

- MFA is enforced for all users.

- IP access is temporary, reducing attack surface.

- Security Group rules are updated dynamically, preventing unauthorized access.

License

This project is licensed under the MIT License.

