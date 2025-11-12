data "ciscomcd_service_object" "internet"{
  name = "internet"
}

data "ciscomcd_service_object" "ssh"{
  name = "ssh"
}

data "ciscomcd_service_object" "icmp"{
  name = "icmp"
}

resource "ciscomcd_policy_rule_set" "ingress_policy" {
  name = var.ciscomcd_ingress_policy_rule_set_name
}


resource "ciscomcd_policy_rule_set" "egressew_policy" {
  name = var.ciscomcd_egress_policy_rule_set_name
}


resource "ciscomcd_policy_rules" "aksdubey-ingress-policy_rules" {
  rule_set_id = ciscomcd_policy_rule_set.ingress_policy.id
  rule {
    name                   = "web_server"
    action                 = "Allow Log"
    state                  = "ENABLED"
    service                = 37
    source                 = 8
    packet_capture_enabled = false
    send_deny_reset        = false
    type                   = "ReverseProxy"
  }
  rule {
        name        = "deny_ssh"
        action      = "Deny Log"
        state       = "ENABLED"
        service     = data.ciscomcd_service_object.ssh.id
        source      = data.ciscomcd_address_object.any_private_rfc1918_ag.id
        destination = data.ciscomcd_address_object.any_private_rfc1918_ag.id
        type        = "Forwarding"
    }
  rule {
        name        = "private-to-p"
        action      = "Deny Log"
        state       = "ENABLED"
        service     = data.ciscomcd_service_object.icmp.id
        source      = data.ciscomcd_address_object.any_private_rfc1918_ag.id
        destination = data.ciscomcd_address_object.any_private_rfc1918_ag.id
        type        = "Forwarding"
    }
  rule {
        name        = "private-to-private"
        action      = "Allow Log"
        state       = "ENABLED"
        service     = data.ciscomcd_service_object.internet.id
        source      = data.ciscomcd_address_object.any_private_rfc1918_ag.id
        destination = data.ciscomcd_address_object.any_private_rfc1918_ag.id
        type        = "Forwarding"
    }
}



resource "ciscomcd_policy_rules" "aksdubey-egress-policy_rules" {
	rule_set_id = ciscomcd_policy_rule_set.egressew_policy.id
	rule {
		name = "Allow-Dev-Prod"
		action = "Allow Log"
		state = "ENABLED"
		service = 15
		source = 46
		packet_capture_enabled = false
		send_deny_reset = false
		type = "Forwarding"
		destination = 47
	}
  depends_on = [ ciscomcd_gateway.aws_egress_gw1 ]
}


data "ciscomcd_address_object" "any_private_rfc1918_ag" {
  name = "any-private-rfc1918"
}

# resource "ciscomcd_service_object" "forward_cl" {
#   name         = "forward-cl-nosnat"
#   description  = "Forwarding CL"
#   service_type = "Forwarding"
#   protocol     = "TCP"
#   source_nat   = false
# }

# resource "ciscomcd_policy_rules" "aksdubey-egress-policy_rules" {
# 	rule_set_id = ciscomcd_policy_rule_set.egressew_policy.id
# 	rule {
# 		name = "Allow-Dev-Prod-All"
# 		action = "Allow Log"
# 		state = "ENABLED"
#     service = ciscomcd_service_object.forward_cl.id
# 		source = data.ciscomcd_address_object.any_private_rfc1918_ag.id
# 		type = "Forwarding"
# 		destination = data.ciscomcd_address_object.any_private_rfc1918_ag.id
# 	}
#   depends_on = [ ciscomcd_gateway.aws_egress_gw1 ]
# }