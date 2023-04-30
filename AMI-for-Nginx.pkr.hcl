variable "ami_id" {
    type = string
    default = "ami-007855ac798b5175e"
}

locals {
    timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "nginx" {
    ami_name = "nginx-${local.timestamp}"
    instance_type = "t3.micro"
    region = "us-east-1"
    source_ami = var.ami_id
    ssh_username = "ubuntu"

    tags = {
        Environment = "QA"
    }
}

build {
    sources = ["source.amazon-ebs.nginx"]
    provisioner "shell" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get upgrade -y",
            "sudo apt-get -y install nginx",
            "sudo systemctl restart nginx"
        ]
    }

    post-processor "manifest" {
    output = "nginx-${local.timestamp}.json"
    strip_path = true   
    }
}


