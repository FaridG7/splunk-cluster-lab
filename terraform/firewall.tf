locals {
  tier_cidrs = {
    for t in var.tiers : t.name => t.network_address
  }

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

resource "null_resource" "fw_chain" {
  provisioner "local-exec" {
    interpreter = ["sudo", "bash", "-c"]
    command     = <<-EOT
      iptables -L TF_FIREWALL >/dev/null 2>&1 || iptables -N TF_FIREWALL

      iptables -C FORWARD -j TF_FIREWALL >/dev/null 2>&1 \
        || iptables -I FORWARD -j TF_FIREWALL
    EOT
  }

  provisioner "local-exec" {
    when = destroy

    interpreter = ["sudo", "bash", "-c"]
    command     = <<-EOT
      iptables -D FORWARD -j TF_FIREWALL >/dev/null 2>&1 || true
      iptables -F TF_FIREWALL >/dev/null 2>&1 || true
      iptables -X TF_FIREWALL >/dev/null 2>&1 || true
    EOT
  }

  depends_on = [module.tier]
}

resource "null_resource" "fw_rules" {
  for_each = local.fw_rules

  triggers = {
    src_cidr = each.value.src_cidr
    dst_cidr = each.value.dst_cidr
    proto    = each.value.proto
    port     = each.value.port
  }

  provisioner "local-exec" {
    interpreter = ["sudo", "bash", "-c"]

    command = <<-EOT
      iptables -C TF_FIREWALL \
        -m conntrack --ctstate NEW \
        -s ${self.triggers.src_cidr} \
        -d ${self.triggers.dst_cidr} \
        -p ${self.triggers.proto} \
        --dport ${self.triggers.port} \
        -j ACCEPT >/dev/null 2>&1 \
      || iptables -A TF_FIREWALL \
        -m conntrack --ctstate NEW \
        -s ${self.triggers.src_cidr} \
        -d ${self.triggers.dst_cidr} \
        -p ${self.triggers.proto} \
        --dport ${self.triggers.port} \
        -m comment --comment "terraform-${each.key}" \
        -j ACCEPT
    EOT
  }

  provisioner "local-exec" {
    when = destroy

    interpreter = ["sudo", "bash", "-c"]

    command = <<-EOT
      iptables -D TF_FIREWALL \
        -m conntrack --ctstate NEW \
        -s ${self.triggers.src_cidr} \
        -d ${self.triggers.dst_cidr} \
        -p ${self.triggers.proto} \
        --dport ${self.triggers.port} \
        -m comment --comment "terraform-${each.key}" \
        -j ACCEPT \
      || true
    EOT
  }

  depends_on = [null_resource.fw_chain]
}
resource "null_resource" "nat_rules" {
  for_each = {
    for t in var.tiers : t.name => t.network_address
  }

  triggers = {
    cidr = each.value
  }

  provisioner "local-exec" {
    interpreter = ["sudo", "bash", "-c"]

    command = <<-EOT
      IFACE=$(ip route show default | awk '/default/ {print $5}')

      iptables -t nat -C POSTROUTING \
        -s ${self.triggers.cidr} \
        -o "$IFACE" \
        -j MASQUERADE >/dev/null 2>&1 \
      || iptables -t nat -A POSTROUTING \
        -s ${self.triggers.cidr} \
        -o "$IFACE" \
        -j MASQUERADE
    EOT
  }

  provisioner "local-exec" {
    when = destroy

    interpreter = ["sudo", "bash", "-c"]

    command = <<-EOT
      IFACE=$(ip route show default | awk '/default/ {print $5}')

      iptables -t nat -D POSTROUTING \
        -s ${self.triggers.cidr} \
        -o "$IFACE" \
        -j MASQUERADE || true
    EOT
  }
}
