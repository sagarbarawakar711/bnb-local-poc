### IAM Policy for SES
resource "aws_iam_policy" "ses_send_emails" {
  name        = "SESSendEmails"
  description = "Policy for sending emails via SES"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ],
    "Resource": "*"
  }]
}
EOF
}
### IAM User
data "aws_iam_user" "smtp_user" {
  user_name = "sep-ses-smtp-user"
}
resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  user       = data.aws_iam_user.smtp_user.user_name
  policy_arn = aws_iam_policy.ses_send_emails.arn
}
