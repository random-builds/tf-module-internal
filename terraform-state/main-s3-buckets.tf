module "main" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.2.0"

  bucket        = "${var.base_bucket_name}-main"
  attach_policy = true
  policy        = data.aws_iam_policy_document.main_bucket_policy.json

  replication_configuration = {
    role = aws_iam_role.replication.arn
    rules = [
      {
        id                        = "${var.base_bucket_name}-replication"
        status                    = "Enabled"
        delete_marker_replication = true

        destination = {
          bucket        = module.backup.s3_bucket_arn
          storage_class = "STANDARD"
        }
      }
    ]
  }

  versioning = {
    enabled = true
  }
}

module "backup" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "${var.base_bucket_name}-backup"
  attach_policy = true
  policy        = data.aws_iam_policy_document.backup_bucket_policy.json

  versioning = {
    enabled = true
  }

  providers = {
    aws = aws.backup
  }
}