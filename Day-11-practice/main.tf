# Creating IAM user
resource "aws_iam_user" "user" {
  count = length(var.user_name)
  name = var.user_name[count.index]
}

# Create IAM Group
resource "aws_iam_group" "Developers" {
  name = var.group_name
}

# Add Users to Group
resource "aws_iam_group_membership" "membership" {
  name = var.membership_name
  users = aws_iam_user.user[*].name
  group = aws_iam_group.Developers.name
}

# Create IAM Policy
resource "aws_iam_policy" "s3_read_policy" {
  name = "S3ReadOnlyPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetObjectVersion"
        ]
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      }
    ]
  })
}

# Attach Policy to Group
resource "aws_iam_group_policy_attachment" "attach" {
  group = aws_iam_group.Developers.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

# Create IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "EC2-S3-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach S3 ReadOnly Managed Policy to Role
resource "aws_iam_role_policy_attachment" "role_attach" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}