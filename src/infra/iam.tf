resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "k8s-EC2-Role"
  assume_role_policy = file("./infra/files/assumerolepolicy.json")
}

resource "aws_iam_policy" "policy" {
  name        = "k8s-EC2-Policy"
  description = "k8s EC2 Policy"
  policy      = file("./infra/files/iam.json")
}
