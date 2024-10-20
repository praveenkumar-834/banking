resource "aws_instance" "test-server" {
  ami = "ami-0dee22c13ea7a9a67"
  instance_type = "t2.micro"
  subnet_id = "vpc-08fe6da40ab27c6b5"
  key_name = "mykey"
  vpc_security_group_ids = ["sg-031c7721f036e4df7"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./mykey.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/banking/terraform-files/ansibleplaybook.yml"
     }
  }
