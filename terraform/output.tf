resource "local_file" "ansible_inventory" {
  filename = var.ansible_inventory_path
  content = join("\n", flatten([
    [
      for tier_name, tier_mod in module.tier : concat(
        ["[${tier_name}]"],
        [
          for host, ip in tier_mod.domains :
          "${host} ansible_host=${ip} ansible_user=ansible"
        ],
        [""]
      )
    ],
    ["[all:children]"],
    [for tier_name, _ in module.tier : tier_name]
  ]))
}
