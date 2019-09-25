data "template_file" "user_data" {
  template = file("user_data.yml")
}

data "template_cloudinit_config" "vault-nodes" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "init.cfg"
    content      = "${data.template_file.user_data.rendered}"
  }
}