resource "ciscomcd_profile_fqdn" "fqdn_filter1" {
  name        = "fqdn_filter1"
  description = "FQDN filter list"
  fqdn_filter_list {
    fqdn_list = [
      "www\\.website1\\.com",
      ".*\\.website2\\.com",
      "www.test.com",
      "test.com"
    ]
    policy               = "Allow Log"
    decryption_exception = false
  }
  fqdn_filter_list {
    fqdn_list = [
      "www\\.website3\\.com",
      "www\\.website4\\.com"
    ]
    policy               = "Deny Log"
    decryption_exception = false
  }
  fqdn_filter_list {
    vendor_category_list {
      vendor = "BRIGHTCLOUD"
      categories = [
        "Spyware and Adware",
        "Malware",
        "Botnets",
        "Open Mail Relay",
        "Poor Sender Reputation",
        "High Risk Sites and Locations",
        "Spam",
        "TOR Exit Nodes",
        "Mobile Threats",
        "Graymail",
        "Spoofing",
        "P2P Malware Node",
        "Open HTTP Proxy",
        "Lying DNS",
        "Newly Seen Domains",
        "DNS Tunneling",
        "Linkshare",
        "Cryptojacking",
        "Dynamic DNS",
        "Potential DNS Rebinding",
        "Bogon",
        "Exploits",
        "Malicious Sites",
        "Indicators of Compromise (IOC)",
        "Scam",
        "Ebanking Fraud",
        "Domain Generated Algorithm",
        "Phishing"
      ]
    }
    policy = "Deny Log"
  }
  fqdn_filter_list {
    vendor_category_list {
      vendor = "BRIGHTCLOUD"
      categories = [
        "Child Abuse Content"
      ]
    }
    policy = "Deny Log"
  }
  uncategorized_fqdn_filter {
    policy               = "Deny Log"
    decryption_exception = false
  }
  default_fqdn_filter {
    policy               = "Deny No Log"
    decryption_exception = false
  }
}

resource "ciscomcd_profile_fqdn" "fqdn_filter2" {
  name        = "fqdn_filter2"
  description = "FQDN filter list"
  fqdn_filter_list {
    fqdn_list = [
      "www\\.web1\\.com",
      ".*\\.web2\\.com",
      "www.test1.com"
    ]
    policy               = "Allow Log"
    decryption_exception = false
  }
}


resource "ciscomcd_profile_fqdn" "fqdn_filter_group" {
  name           = "fqdn_filter_group"
  description    = "FQDN filter group"
  type           = "GROUP"
  group_member_ids = [
    ciscomcd_profile_fqdn.fqdn_filter1.id,
    ciscomcd_profile_fqdn.fqdn_filter2.id
  ]
  uncategorized_fqdn_filter {
          policy               = "Deny No Log"
          decryption_exception = false
  }
  default_fqdn_filter {
          policy               = "Deny Log"
          decryption_exception = false
  }
}