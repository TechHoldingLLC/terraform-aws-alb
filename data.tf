####################
# alb/data.tf      #
####################

data "aws_caller_identity" "current" {}

# Pre-create CloudWatch Logs resource policy to prevent concurrent delivery races.
# When multiple ALB Access log types are enabled, all deliveries try to auto-provision the policy
# simultaneously, causing AccessDeniedException. Creating it explicitly avoids this.
data "aws_iam_policy_document" "alb_log_delivery" {
  count = var.create_alb && var.enable_cloudwatch_logs ? 1 : 0

  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.alb[0].arn}:log-stream:*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [for k in local.cloudwatch_log_types : aws_cloudwatch_log_delivery_source.alb[k].arn]
    }
  }
}
