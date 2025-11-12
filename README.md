# Cisco Multicloud Defense Gateway Deployment

This Terraform configuration deploys Cisco Multicloud Defense (MCD) security gateways in AWS, providing comprehensive network security for multi-VPC environments through a centralized hub-and-spoke architecture.

## Architecture Overview

The deployment creates:
- **Service VPC**: A dedicated security VPC containing MCD gateways
- **Transit Gateway**: AWS TGW for connecting service VPC with spoke VPCs
- **Security Gateways**: Egress/Ingress gateways with auto-scaling capabilities
- **Policy Enforcement**: Rule-based security policies for traffic inspection
- **FQDN Filtering**: Domain-based access control with category-based blocking

## Prerequisites

1. **AWS Account**: Properly configured with appropriate permissions
2. **Cisco MCD Account**: Active account with API access
3. **AWS CLI**: Configured with appropriate credentials
4. **Terraform**: Version 0.12+ installed
5. **SSH Key Pair**: Pre-created in AWS for gateway access
6. **IAM Role**: `ciscomcd-gateway-role` must exist in your AWS account

## Required Files

- `cl.json`: Cisco MCD API credentials file (see example structure below)
- `terraform.tfvars`: Variable definitions specific to your environment

## Configuration Files

### Core Infrastructure
- `provider.tf`: Terraform providers (AWS & Cisco MCD)
- `variables.tf`: Variable definitions
- `service_vpc.tf`: Service VPC configuration
- `transit_gw.tf`: AWS Transit Gateway setup

### Security Components
- `instance.tf`: Gateway instance configurations
- `policy_ruleset.tf`: Security policy definitions
- `fqdn.tf`: FQDN filtering profiles

### Network Integration
- `spoke_vpc.tf`: Spoke VPC connections (currently commented)
- `vpc_route.tf`: Route table configurations (currently commented)

## Quick Start

### 1. Prepare API Credentials

Create an API key for Multicloud Defense controller:
System and Accounts -> API Key
Create a key with read_write privileges
Download the file which will be a json, here represented as cl.json

### 2. Configure Variables

Update `terraform.tfvars` with your environment specifics:
```hcl
aws_account_name                      = "your-aws-account-name"
zones                                 = ["us-east-1a", "us-east-1b"]
prefix                                = "your-prefix"
vpc_cidr                              = "10.0.0.0/16"
region                                = "us-east-1"
ciscomcd_api_key_file                 = "cl.json"
gateway_image                         = "24.06-08"
ciscomcd_egress_policy_rule_set_name  = "your-egress-policy"
ciscomcd_ingress_policy_rule_set_name = "your-ingress-policy"
spoke_vpcs = {
  "vpc1" = {
    spoke_vpc_id      = "vpc-xxxxxxxxx"
    spoke_vpc_subnets = ["subnet-xxxxxxxxx"]
  }
}
```

### 3. Deploy

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply
```

## Configuration Parameters

### Required Variables
| Variable | Description | Example |
|----------|-------------|---------|
| `aws_account_name` | AWS account name in MCD | "my-aws-account" |
| `ciscomcd_api_key_file` | Path to MCD API credentials | "cl.json" |
| `gateway_image` | MCD gateway image version | "24.06-08" |

### Network Configuration
| Variable | Description | Default |
|----------|-------------|---------|
| `region` | AWS region | "us-east-1" |
| `zones` | Availability zones | `["us-east-1a"]` |
| `vpc_cidr` | Service VPC CIDR block | "10.0.0.0/16" |
| `vpc_subnet_bits` | Additional subnet bits | 8 |

### Gateway Configuration
| Variable | Description | Default |
|----------|-------------|---------|
| `ciscomcd_egress_gateway_autoscale_min` | Minimum gateway instances | 1 |
| `ciscomcd_egress_gateway_autoscale_max` | Maximum gateway instances | 3 |
| `ciscomcd_svpc_use_nat_gateway` | Enable NAT gateway | false |

## Security Policies

The deployment includes predefined security policies:

### Egress Policy Rules
- **Allow-Dev-Prod**: Permits specific inter-VPC communication
- Configured in `policy_ruleset.tf`

### Ingress Policy Rules
- **web_server**: Allows web traffic with logging
- **deny_ssh**: Blocks SSH access between private networks
- **private-to-private**: Controls private network communication

### FQDN Filtering
- Domain-based access control
- Category-based blocking (malware, botnets, etc.)
- Custom domain allow/deny lists

## Spoke VPC Integration

To connect spoke VPCs:

1. Uncomment spoke VPC resources in `spoke_vpc.tf`
2. Update `spoke_vpcs` variable with your VPC details
3. Configure route tables in `vpc_route.tf`

Example spoke VPC configuration:
```hcl
spoke_vpcs = {
  "production" = {
    spoke_vpc_id      = "vpc-041cf222ce0127bdf"
    spoke_vpc_subnets = ["subnet-079956665ccec8d48"]
  },
  "development" = {
    spoke_vpc_id      = "vpc-064b704ea2df4c700"
    spoke_vpc_subnets = ["subnet-06876230d4f333483"]
  }
}
```

## Monitoring and Logging

- All policies include logging capabilities
- Gateway instances support packet capture profiles
- Integration with AWS CloudWatch for monitoring

## Troubleshooting

### Common Issues

1. **API Authentication Failures**
   - Verify `cl.json` credentials are valid
   - Check API server connectivity

2. **Gateway Deployment Failures**
   - Ensure IAM role `ciscomcd-gateway-role` exists
   - Verify SSH key pair is available in the region

3. **Policy Rule Conflicts**
   - Check rule priorities and overlapping conditions
   - Validate service and address object references

### Useful Commands

```bash
# Check gateway status
terraform state show ciscomcd_gateway.aws_egress_gw1

# Validate configuration
terraform validate

# View current state
terraform show

# Destroy infrastructure
terraform destroy
```

## Security Considerations

- Store `cl.json` securely and never commit to version control
- Use least-privilege IAM policies
- Regularly update gateway images
- Monitor policy rule effectiveness
- Implement proper backup and disaster recovery procedures

## Support

For issues and questions:
- Check Cisco MCD documentation
- Review Terraform provider documentation
- Contact your Cisco support representative

## Version Compatibility

- **Terraform**: >= 0.12
- **Cisco MCD Provider**: 0.2.9
- **AWS Provider**: Latest
- **Gateway Image**: latest available

---