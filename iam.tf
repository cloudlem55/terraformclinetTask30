# resource "aws_iam_role" "awesome_service_asg_role" {
#     name = "abc"
#     assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "autoscaling.amazonaws.com"
#       },
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "awesome_service_asg_role_policy" {
#     name = "xyz"
#     role = "${aws_iam_role.awesome_service_asg_role.id}"
#     policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "sns:Publish"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_sns_topic" "user_updates" {
#   name            = "user-updates-topic"
#   delivery_policy = <<EOF
# {
#   "http": {
#     "defaultHealthyRetryPolicy": {
#       "minDelayTarget": 20,
#       "maxDelayTarget": 20,
#       "numRetries": 3,
#       "numMaxDelayRetries": 0,
#       "numNoDelayRetries": 0,
#       "numMinDelayRetries": 0,
#       "backoffFunction": "linear"
#     },
#     "disableSubscriptionOverrides": false,
#     "defaultThrottlePolicy": {
#       "maxReceivesPerSecond": 1
#     }
#   }
# }
# EOF
# }
# resource "aws_autoscaling_lifecycle_hook" "foobar" {
#   name                   = "foobar"
#   autoscaling_group_name = aws_autoscaling_group.test-autoscaling-group.name
#   default_result         = "CONTINUE"
#   heartbeat_timeout      = 2000
#   lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

#   notification_metadata = <<EOF
# {
#   "foo": "bar"
# }
# EOF

#   notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#   role_arn                = "arn:aws:iam::123456789012:role/S3Access"
# }