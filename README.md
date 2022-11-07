# AWS VPC Terraform module

Terraform module which creates a custom VPC. You can define public and private subnets. <br>
**NB**: private subnets are optional.

**Things that will be created**
* VPC;
* Internet gateway to the public subnets;
* Route table to the public subnets;
* The public subnets.

**Things that will be created if you define private subnets**
* NAT to guarantee internet access to the private subnets;
* Route table to the private subnets;
* The private subnets.

## Requirements
The module was tested using:
| Name | Versions |
|------|----------|
| terraform | >= 1.0 |
| aws provider | >= 3.0 |

## Usage

### Creating a VPC with 2 public subnets
```hcl
variable "public_subnets"{
    type = list(map(string))
    default = [
        {
            availability_zone = "us-east-1a"
            cidr_block = "10.0.1.0/24"
        },
        {
            availability_zone = "us-east-1b"
            cidr_block = "10.0.2.0/24"
        }
    ]
}

module "example_vpc" {
    source          = ...
    vpc_name        = "my-vpc"
    vpc_cidr_block  = "10.0.0.0/16"
    public_subnets  = var.public_subnets
}
```

### Creating a VPC with 2 public subnets and 2 private subnets
```hcl
variable "public_subnets"{
    type = list(map(string))
    default = [
        {
            availability_zone = "us-east-1a"
            cidr_block = "10.0.1.0/24"
        },
        {
            availability_zone = "us-east-1b"
            cidr_block = "10.0.2.0/24"
        }
    ]
}

variable "private_subnets"{
    type = list(map(string))
    default = [
        {
            availability_zone = "us-east-1a"
            cidr_block = "10.0.3.0/24"
        },
        {
            availability_zone = "us-east-1b"
            cidr_block = "10.0.4.0/24"
        }
    ]
}

module "example_vpc" {
    source          = ...
    vpc_name        = "my-vpc"
    vpc_cidr_block  = "10.0.0.0/16"
    public_subnets  = var.public_subnets
    private_subnets = var.private_subnets
}
```

## Resources

| Name | Type |
|------|------|
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_internet_gateway.vpc_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.vpc_main_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_main_route_table_association.vpc_main_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association) | resource |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | list of resources |
| [aws_route_table_association.public_subnets_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | list of resources |
| [aws_eip.public_nat_gateway_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | list of one resource |
| [aws_nat_gateway.public_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | list of one resource |
| [aws_route_table.vpc_private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | list of one resource |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | list of resources |
| [aws_route_table_association.private_subnets_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | list of resources |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Tag 'Environment' for all resources | string | " " | no |
| managed_by | Tag 'Managed_by' for all resources | string | " " | no |
| vpc_name | Tag 'Name' of the VPC. Other resources will use the vpc_name as a prefix  | string | null | yes |
| vpc_cidr_block | The VPC cidr block | string | null | yes |
| public_subnets | List of public subnets data, one subnet must have "availability_zone" and "cidr_block" | list(map(string)) | null | yes |
| private_subnets | List of private subnets data, one subnet must have "availability_zone" and "cidr_block" | list(map(string)) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The VPC id |
| internet_gateway_id | The internet gateway id  |
| public_subnet_ids | List of public subnets ids |
| private_subnet_ids | List of private subnets ids |


## DevInfos:
- Name: James Artur (Thunder);
- A DevOps and infrastructure enthusiastics.