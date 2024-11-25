THG Bin Project
variables.tf: Defines inputs (e.g., bucket_name or aws_region) that users can customize.
main.tf: Uses these variables to configure resources (e.g., an S3 bucket or a VPC).
outputs.tf: Provides outputs (e.g., s3_bucket_arn or vpc_id) to make the configuration results accessible for downstream use.
