#_____________________VPC___________________________#

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name        = var.vpc_name
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}


#______________INTERNET_GATEWAY_____________#

resource "aws_internet_gateway" "vpc_internet_gateway"{
    vpc_id  = aws_vpc.vpc.id
    tags = {
        Name        =  "${var.vpc_name}-internet-gateway"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}


#___________________________________PUBLIC_PART____________________________________#

#_________MAIN_ROUTE_TABLE___________________#

resource "aws_route_table" "vpc_main_route_table" {
    vpc_id = aws_vpc.vpc.id
    #internet route
    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.vpc_internet_gateway.id
    }
    tags = {
        Name        = "${var.vpc_name}-main-route-table"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}

#___________ROUTE_TABLE_ASSOCIATION___________________#

resource "aws_main_route_table_association" "vpc_main_route_table_association" {
    vpc_id          = aws_vpc.vpc.id
    route_table_id  = aws_route_table.vpc_main_route_table.id
}


#__________PUBLIC_SUBNETS_______________________#

resource "aws_subnet" "public_subnets" {
    count             = length(var.public_subnets)
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.public_subnets[count.index]["cidr_block"]
    availability_zone = var.public_subnets[count.index]["availability_zone"]
    tags = {
        Name        = "${var.vpc_name}-public-subnet${count.index}-${var.public_subnets[count.index]["availability_zone"]}"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}

#__________PUBLIC_SUBNETS_ASSOCIATION_____________#

resource "aws_route_table_association" "public_subnets_route_table_association"{
    count           = length(var.public_subnets)
    subnet_id       = aws_subnet.public_subnets[count.index].id
    route_table_id  = aws_route_table.vpc_main_route_table.id
}


#___________________NAT_GATEWAY____________________#

resource "aws_eip" "public_nat_gateway_eip" {
    depends_on  = [aws_internet_gateway.vpc_internet_gateway]
    count       = length(var.private_subnets)>0? 1:0
    vpc         = true
    tags = {
        Name        = "${var.vpc_name}-public-nat-gateway-eip"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}

resource "aws_nat_gateway" "public_nat_gateway" {
    depends_on      = [aws_eip.public_nat_gateway_eip, aws_subnet.public_subnets]
    count           = length(var.private_subnets)>0? 1:0
    allocation_id   = aws_eip.public_nat_gateway_eip[0].id
    subnet_id       = aws_subnet.public_subnets[0].id

    tags = {
        Name        = "${var.vpc_name}-public-nat-gateway"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}


#___________________________________PRIVATE_PART____________________________________#

#_________PRIVATE_ROUTE_TABLE______________________#

resource "aws_route_table" "vpc_private_route_table" {
    vpc_id  = aws_vpc.vpc.id
    count   = length(var.private_subnets)>0? 1:0
    #Nat gateway route
    route {
        cidr_block      = "0.0.0.0/0"
        nat_gateway_id  = aws_nat_gateway.public_nat_gateway[0].id
    }
    tags = {
        Name        = "${var.vpc_name}-private-route-table"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}

#__________PRIVATE_SUBNETS_______________________#

resource "aws_subnet" "private_subnets" {
    count             = length(var.private_subnets)
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_subnets[count.index]["cidr_block"]
    availability_zone = var.private_subnets[count.index]["availability_zone"]
    tags = {
        Name        = "${var.vpc_name}-private-subnet${count.index}-${var.private_subnets[count.index]["availability_zone"]}"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}

#__________PUBLIC_SUBNETS_ASSOCIATION_____________#

resource "aws_route_table_association" "private_subnets_route_table_association"{
    count           = length(var.private_subnets)
    subnet_id       = aws_subnet.private_subnets[count.index].id
    route_table_id  = aws_route_table.vpc_private_route_table[0].id
}