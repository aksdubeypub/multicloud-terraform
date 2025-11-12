# resource "aws_default_route_table" "dev_vpc1" {
#   default_route_table_id = "rtb-0cd5447ba685cac77"
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_ec2_transit_gateway.ciscomcd_tgw.id
#   }
#   depends_on = [ aws_ec2_transit_gateway.ciscomcd_tgw, ciscomcd_gateway.aws_ingress_gw1, ciscomcd_gateway.aws_ingress_gw1]
# }


# resource "aws_default_route_table" "prod_vpc" {
#   default_route_table_id = "rtb-033f9d1fcd0eba558"

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_ec2_transit_gateway.ciscomcd_tgw.id
#   }

#   route {
#     cidr_block = "83.97.13.0/24"
#     gateway_id = "igw-0fc0cfae42703abb7"
#   }

#   depends_on = [ aws_ec2_transit_gateway.ciscomcd_tgw, ciscomcd_gateway.aws_ingress_gw1, ciscomcd_gateway.aws_ingress_gw1]
# }

# resource "aws_default_route_table" "prod_vpc1" {
#   default_route_table_id = "rtb-033f9d1fcd0eba558"

#   route {
#     cidr_block = "83.97.13.0/24"
#     gateway_id = "igw-0fc0cfae42703abb7"
#   }
#   depends_on = [ aws_ec2_transit_gateway.ciscomcd_tgw, ciscomcd_gateway.aws_ingress_gw1, ciscomcd_gateway.aws_ingress_gw1]
# }
