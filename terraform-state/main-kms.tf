resource "aws_kms_key" "main" {
  deletion_window_in_days = 7
  enable_key_rotation     = true
  rotation_period_in_days = 180
  multi_region            = true
  description             = "Used for encrypting s3 state buckets"
}

resource "aws_kms_replica_key" "replica" {
  description             = "Replica key for s3 state buckets"
  deletion_window_in_days = 7
  primary_key_arn         = aws_kms_key.main.arn

  provider = aws.replica
}