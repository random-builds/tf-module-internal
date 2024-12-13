data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "replication" {
  name               = "${var.base_bucket_name}-replication"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [module.main.s3_bucket_arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]

    resources = ["${module.main.s3_bucket_arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]

    resources = ["${module.backup.s3_bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "replication" {
  name   = "${var.base_bucket_name}-replication"
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

data "aws_iam_policy_document" "main_bucket_policy" {
  statement {
    actions = [
      "s3:DeleteBucket",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
    ]
    resources = [
      module.main.s3_bucket_arn,
      "${module.main.s3_bucket_arn}/*",
    ]
    principals {
      type = "AWS"
      identifiers = [
        "*",
      ]
    }
    effect = "Deny"
  }
}

data "aws_iam_policy_document" "backup_bucket_policy" {
  statement {
    actions = [
      "s3:DeleteBucket",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
    ]
    resources = [
      module.backup.s3_bucket_arn,
      "${module.backup.s3_bucket_arn}/*",
    ]
    principals {
      type = "AWS"
      identifiers = [
        "*",
      ]
    }
    effect = "Deny"
  }
}