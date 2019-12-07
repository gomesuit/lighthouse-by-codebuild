resource "aws_cloudwatch_event_rule" "webperf-by-codebuild" {
  name                = "exec-webperf-by-codebuild-${random_id.webperf.hex}"
  schedule_expression = "cron(0 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "webperf-by-codebuild" {
  rule     = aws_cloudwatch_event_rule.webperf-by-codebuild.name
  arn      = aws_codebuild_project.webperf-by-codebuild.arn
  role_arn = aws_iam_role.webperf-by-codebuild-invoke-codebuild.arn
}

resource "aws_iam_role" "webperf-by-codebuild-invoke-codebuild" {
  name = "webperf-by-codebuild-invoke-codebuild-${random_id.webperf.hex}"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invoke-codebuild" {
  name = "invoke-codebuild"
  role = aws_iam_role.webperf-by-codebuild-invoke-codebuild.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:StartBuild"
      ],
      "Resource": [
        "${aws_codebuild_project.webperf-by-codebuild.arn}"
      ]
    }
  ]
}
EOF
}
