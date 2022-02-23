data "aws_ami" "jenkinsimage" {
  owners      = ["self"]
  name_regex  = "^jen"
  most_recent = true
}