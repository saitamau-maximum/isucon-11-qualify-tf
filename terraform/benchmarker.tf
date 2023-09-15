resource "sakuracloud_server" "isucon11q-benchmarker" {
  name = "${var.team_name}-bench"
  zone = var.zone

  core   = 4
  memory = 8
  disks  = [sakuracloud_disk.isucon11q-benchmarker.id]

  network_interface {
    upstream = "shared"
  }

  network_interface {
    upstream = sakuracloud_switch.isucon11q-switch.id
  }

  user_data = join("\n", [
    "#cloud-config",
    local.cloud-config,
    yamlencode({
      ssh_pwauth : false,
      ssh_authorized_keys : [
        file(var.public_key_path),
      ],
    }),
  ])
}

resource "sakuracloud_disk" "isucon11q-benchmarker" {
  name = "${var.team_name}-bench"
  zone = var.zone

  size              = 20
  source_archive_id = data.sakuracloud_archive.ubuntu.id
}

data "http" "benchmarker-cloud-config-source" {
  url = "https://raw.githubusercontent.com/saitamau-maximum/isucon-11-qualify-tf/main/cloud-init/bench.cfg"
}
locals {
  cloud-config = replace(data.http.cloud-config-source.body, "#cloud-config", "")
}

output "ip_address" {
  value = sakuracloud_server.isucon11q-benchmarker.ip_address
}
