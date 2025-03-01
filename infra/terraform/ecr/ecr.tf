resource "aws_ecr_repository" "rest-api-server-repository" {
  name      = "rest-api-server-repository"
  image_tag_mutability = "MUTABLE"
    force_delete = true
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:GetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr_policy"
  description = "Allow ECR access"
  policy      = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_iam_role" "ecr_role" {
  name               = "ecr_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ecr.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_attachment" {
  role       = aws_iam_role.ecr_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}
