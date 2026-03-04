# ============================================================================
# INTENTIONALLY VULNERABLE TERRAFORM FILE - FOR SECURITY SCANNER TESTING ONLY
# This file contains deliberate misconfigurations to trigger Checkov findings.
# DO NOT deploy this infrastructure.
# ============================================================================

# --- AWS S3 Bucket: No encryption, no versioning, no logging, public access ---

resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "my-insecure-test-bucket"
  acl    = "public-read"

  tags = {
    Environment = "test"
    Purpose     = "scanner-testing"
  }
}

resource "aws_s3_bucket_public_access_block" "vulnerable_bucket_access" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# --- Security Group: 0.0.0.0/0 ingress on all ports ---

resource "aws_security_group" "wide_open" {
  name        = "wide-open-sg"
  description = "Intentionally insecure security group"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all inbound TCP traffic"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all inbound UDP traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Azure Storage Account: No HTTPS, no network rules ---

resource "azurerm_storage_account" "insecure_storage" {
  name                      = "insecurestorageacct"
  resource_group_name       = "test-rg"
  location                  = "eastus"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = false
  min_tls_version           = "TLS1_0"

  tags = {
    environment = "test"
  }
}

# --- EC2 Instance: No monitoring, no IMDSv2 ---

resource "aws_instance" "unmonitored_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  monitoring    = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  tags = {
    Name = "unmonitored-instance"
  }
}

# --- RDS Instance: No encryption, publicly accessible ---

resource "aws_db_instance" "insecure_rds" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "admin"
  password               = "SuperSecret123!"
  publicly_accessible    = true
  storage_encrypted      = false
  skip_final_snapshot    = true
  backup_retention_period = 0
}

# --- CloudTrail: No log file validation, no encryption ---

resource "aws_cloudtrail" "insecure_trail" {
  name                       = "insecure-trail"
  s3_bucket_name             = aws_s3_bucket.vulnerable_bucket.id
  enable_log_file_validation = false
  is_multi_region_trail      = false
}
