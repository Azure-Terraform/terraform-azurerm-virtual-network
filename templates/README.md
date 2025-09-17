# Templates Directory

This directory contains Docker and shell script templates for the terraform-azurerm-virtual-network module.

## Files

### Dockerfile
A clean Dockerfile based on Ubuntu 24.04 LTS that includes:
- Essential development tools (curl, wget, git, jq)
- Terraform CLI
- Azure CLI
- Non-root user setup with sudo access
- Minimal attack surface

**Usage:**
```bash
docker build -t terraform-azure .
docker run -it terraform-azure
```

### create-users.sh
A comprehensive user creation script for Ubuntu 24.04 systems with:
- Secure user creation with proper defaults
- SSH key management
- Group management (including sudo access)
- Password policy enforcement
- Comprehensive logging
- Error handling and validation

**Usage:**
```bash
# Create a basic user
sudo ./create-users.sh myuser

# Create a user with sudo access and SSH key
sudo ./create-users.sh -s -k ~/.ssh/id_rsa.pub myuser

# Create a user with custom groups and disable password auth
sudo ./create-users.sh -s -g docker,www-data -d -k ./pubkey.pub myuser
```

## Security Features

Both templates follow security best practices:
- Non-root user execution where possible
- Minimal package installation
- Proper file permissions
- Input validation
- Comprehensive logging
- Error handling

## Compatibility

These templates are designed for Ubuntu 24.04 LTS and maintain compatibility with the Azure VM configurations in the examples directory.