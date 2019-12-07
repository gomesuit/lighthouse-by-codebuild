resource "aws_s3_bucket" "webperf-by-codebuild-query-result" {
  bucket        = "webperf-by-codebuild-query-result-${random_id.webperf.hex}"
  force_destroy = true
}

resource "aws_s3_bucket" "webperf-by-codebuild" {
  bucket        = "webperf-by-codebuild-${random_id.webperf.hex}"
  force_destroy = true

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "webperf-by-codebuild" {
  bucket = aws_s3_bucket.webperf-by-codebuild.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.webperf-by-codebuild.arn}/*"
    }
  ]
}
POLICY
}
