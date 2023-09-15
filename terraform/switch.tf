resource "sakuracloud_switch" "isucon11q-switch" {
  name = "${var.team_name}-switch"
  zone = var.zone
}
