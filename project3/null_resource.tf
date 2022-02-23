resource "null_resource" "provisioner" {
  triggers = {
    always_run = timestamp()
  }
  connection {
      host = lookup({ for each in aws_instance.server : each.tags_all["Name"] => each.public_ip },"server-QA")
      type = "ssh"
      user = "ec2-user"
      private_key = file("terraform-key.pem")
  }
  provisioner "file" {
    content = "<h1>This is a help page</h1>"
    destination = "/tmp/help.html"
    #on_failure = continue
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 180",
      "sudo cp /tmp/help.html /var/www/html/help.html"
    ]
  }
}