resource "aws_s3_bucket" "Client_bucket" {
  bucket = "my-clienttest-bucket-01"
  acl    = "private"

  tags = {
    Name = "client bucket"
  }
}

