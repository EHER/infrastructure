# 🚀 Infrastructure

This repository contains the Infrastructure as Code (IaC) configurations for the servers used in my pet projects.

## 🔧 Requirements

To get started, you need to install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

Additionally, you will need a provider token, such as the one from [DigitalOcean](https://cloud.digitalocean.com/account/api/tokens).

## 📖 Usage

### 1️⃣ Clone the Repository and Initialize Terraform

```bash
terraform init
```

This command initializes Terraform, setting up the environment from scratch and downloading any required dependencies.

### 2️⃣ Plan the Configuration 📝

To preview the changes Terraform will make, run:

```bash
terraform plan
```

This command will display the execution plan without making any changes to the infrastructure.

### 3️⃣ Apply the Configuration ✅

```bash
terraform apply
```

Terraform will prompt for necessary parameters, such as the provider token, and display the execution plan for review before applying changes.

### 4️⃣ Updating the Infrastructure 🔄

To make changes, update the `main.tf` file and run:

```bash
terraform apply
```

Always commit your changes to ensure the repository accurately reflects the current infrastructure state.


### 5️⃣ Display Infrastructure Details 🌐

After applying your configuration, you can easily find your server’s IP address by displaying the infrastructure details. Use the following command to filter the output and show only the IPv4 address:

```bash
terraform show | grep "ipv4_address"
```

This command extracts the line containing the IPv4 address of your server.

### 6️⃣ Connect to the Server via SSH 🔐

Once you have obtained the server's IP address, you can connect using SSH. If your SSH key is in the default path (`~/.ssh/id_rsa.pub`), Terraform automatically sets it up for access:

```bash
ssh root@<server-ip>
```

Replace `<server-ip>` with the actual IP address obtained from the previous command.

### Example Usage

```bash
# Show the current state of the infrastructure and filter for IP addresses
terraform show | grep "ipv4_address"

# Suppose the output is:
# ipv4_address = "123.45.67.89"

# Connect to the server using SSH
ssh root@123.45.67.89
```

### 7️⃣ Destroying the Environment 🗑️

When the server is no longer needed, remove the infrastructure by running:

```bash
terraform destroy
```

This will clean up all resources associated with the environment.

### 🔑 Using Environment Variables (.env) for Terraform Variables

A `.env.dist` file is available in this repository as a reference for setting up your `.env` file. Define your Terraform variables there, such as:

```ini
TF_VAR_do_token=your_digitalocean_token_here
```

To load these variables into your shell session before running Terraform commands, use the following approach:

```bash
set -o allexport
source .env
set +o allexport
```

Now, you can run Terraform commands as usual:

```bash
terraform plan
terraform apply
```

This method ensures your credentials remain outside the codebase while keeping the workflow secure and organized.

---

✨ Keeping this repository updated ensures a consistent and reproducible infrastructure setup. ✨

