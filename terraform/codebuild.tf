resource "aws_s3_bucket" "codebuild_cache" {
  bucket = "hexlet-basics-codebuild-cache"
  acl    = "private"
}

resource "aws_iam_role" "codebuild_role" {
  name = "hexlet-basics-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "hexlet-basics-codebuild-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name       = "hexlet-basics-codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}

resource "aws_codebuild_project" "hexlet_basics" {
  name         = "hexlet-basics"
  description  = "Hexlet Basics"
  build_timeout      = "5"
  service_role = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = "${aws_s3_bucket.codebuild_cache.bucket}"
  }

  environment {
    privileged_mode = true
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/docker:17.09.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "CONTAINER_REPOSITORY_URL"
      "value" = "${aws_ecr_repository.app.repository_url}"
    }

    environment_variable {
      "name"  = "REF_NAME"
      "value" = "latest"
    }
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/hexlet-basics/hexlet_basics.git"
  }

  /* tags { */
  /*   "Environment" = "Test" */
  /* } */
}
