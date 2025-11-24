# AWS Instance

# Route53 Record

# Null rsource to call provisioners


resource "aws_instance" "main" {
  ami           = data.aws_ami.main.image_id 
  instance_type = var.instance.type
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "${var.name}-${var.env}"
  }

   # We will soon remove this option and this is a workAround
lifecycle {
    ignore_changes = [ami]
  }  
}



# Creates DNS Record

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = "${var.name}-${var.env}.devsecopswithshri.site"
  type = "A"
  ttl = "10"
  records = [aws_instance.main.private_ip]

   # We will soon remove this option and this is a workAround
lifecycle {
    ignore_changes = [zone_id]
  }
}



 

# this is dependent on ec2 instance & route53 record creation, Once both are created successfully, it will execute the command mentioned in local-exec
# For this to control the execution order, we have used depends_on meta-argument.

resource "null_resource" "app" {    

  depends_on = [aws_instance.main, aws_route53_record.main]

  triggers = {
    always_run = true
  }


 # provisioner "local-exec" {
  #  command = "sleep 60; cd /home/ec2-user/Ansible ; ansible-playbook -i inv-${var.env} -e ansible_user=ec2-user -e ansible_password=DevOps321 -e COMPONENT=${var.name} -e ENV=${var.env} expense.yml"
  #}

  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "pip3.11 install hvac",       # Python library to interact with Hashicorp Vault
      "ansible-pull -U https://github.com/Shripad13/Ansible.git  -e COMPONENT=${var.name} -e ENV=${var.env} expense.yml"
    ]
  }

}
