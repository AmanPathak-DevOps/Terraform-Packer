variable "ami_id" {
    type = string
    default = "ami-007855ac798b5175e"
}

locals {
    app_name = "apache2"
}

source "amazon-ebs" "apache2" {
    ami_name = "my-server-${local.app_name}"
    instance_type = "t2.micro"
    region = "us-east-1"
    source_ami = "${var.ami_id}"
    ssh_username = "ubuntu"

    tags = {
        Environment = "Development"
    }
}

build {
    sources = ["source.amazon-ebs.apache2"]
    provisioner "shell" {
        inline = [
            "sudo apt update -y"
            "sudo apt upgrade -y"
            "sudo apt install -y apache2",
            "sudo systemctl restart apache2",
            "sudo systemctl enable apache2"
        ]
    }   
}