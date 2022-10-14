resource "aws_iam_instance_profile" "ec2_iam_profile" {
  name = "k8s-EC2-Profile"
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_iam_role" "ec2_iam_role" {
  name               = "k8s-EC2-Role"
  assume_role_policy = file("./infra/files/assumerolepolicy.json")
}

resource "aws_iam_role_policy_attachment" "ec2_iam_policy_attach" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = aws_iam_policy.ec2_iam_policy.arn
}

resource "aws_iam_policy" "ec2_iam_policy" {
  name        = "k8s-EC2-Policy"
  description = "k8s EC2 Policy"
  policy      = file("./infra/files/iam.json")
}
