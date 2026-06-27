locals {
  tier_cidrs = { for t in var.tiers : t.name => t.network_address }

  fw_rules = {
    for combo in flatten([
      for t in var.tiers : [
        for rule in t.firewall_rules : {
          key      = "${t.name}-to-${rule.dst}-${rule.proto}-${rule.port}"
          src_cidr = t.network_address
          dst_cidr = local.tier_cidrs[rule.dst]
          port     = rule.port
          proto    = rule.proto
        }
      ]
    ]) : combo.key => combo
  }
}

# Ensures LIBVIRT_FWX exists before any rules are inserted.
resource "null_resource" "fw_chain" {
  provisioner "local-exec" {
    interpreter = ["sudo", "bash", "-c"]
    command     = "iptables -L LIBVIRT_FWX >/dev/null 2>&1 || iptables -N LIBVIRT_FWX"
  }

  depends_on = [module.tier]
}

resource "null_resource" "fw_rules" {
  for_each = local.fw_rules

  triggers = {
    src_cidr = each.value.src_cidr
    dst_cidr = each.value.dst_cidr
    port     = each.value.port
    proto    = each.value.proto
  }

  provisioner "local-exec" {
    interpreter = ["sudo", "bash", "-c"]
    command     = <<-EOT
      iptables -C LIBVIRT_FWX \
        -s ${self.triggers.src_cidr} \
        -d ${self.triggers.dst_cidr} \
        -p ${self.triggers.proto} \
        --dport ${self.triggers.port} \
        -j ACCEPT 2>/dev/null \
      || iptables -I LIBVIRT_FWX \
        -s ${self.triggers.src_cidr} \
        -d ${self.triggers.dst_cidr} \
        -p ${self.triggers.proto} \
        --dport ${self.triggers.port} \
        -j ACCEPT \
        -m comment --comment "terraform-${each.key}"
    EOT
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["sudo", "bash", "-c"]
    command     = <<-EOT
      iptables -D LIBVIRT_FWX \
        -s ${self.triggers.src_cidr} \
        -d ${self.triggers.dst_cidr} \
        -p ${self.triggers.proto} \
        --dport ${self.triggers.port} \
        -j ACCEPT \
        -m comment --comment "terraform-${each.key}" \
      || true
    EOT
  }

  depends_on = [null_resource.fw_chain]
}
