#########################
# alb/cloudwatch.tf     #
#########################

#-------------ALB logs to CloudWatch Logs-------------#
locals {
  cloudwatch_log_types = var.create_alb && var.enable_cloudwatch_logs ? toset(var.cloudwatch_log_types) : toset([])
}

resource "aws_cloudwatch_log_group" "alb" {
  count             = var.create_alb && var.enable_cloudwatch_logs ? 1 : 0
  name              = coalesce(var.cloudwatch_log_group_name, "/aws/alb/${var.name}")
  retention_in_days = var.cloudwatch_log_retention_in_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_resource_policy" "alb" {
  count           = var.create_alb && var.enable_cloudwatch_logs ? 1 : 0
  policy_name     = "AWSLogDeliveryWrite-${var.name}"
  policy_document = data.aws_iam_policy_document.alb_log_delivery[0].json
}

resource "aws_cloudwatch_log_delivery_source" "alb" {
  for_each     = local.cloudwatch_log_types
  name         = "${var.name}-${lower(replace(each.key, "_", "-"))}"
  log_type     = each.key
  resource_arn = aws_lb.alb[0].arn
  tags         = var.tags
}

## One destination per log type to avoid ConflictException on concurrent deliveries to the same destination
resource "aws_cloudwatch_log_delivery_destination" "alb" {
  for_each = local.cloudwatch_log_types
  name     = "${var.name}-${lower(replace(each.key, "_", "-"))}"
  tags     = var.tags

  delivery_destination_configuration {
    destination_resource_arn = aws_cloudwatch_log_group.alb[0].arn
  }
}

resource "aws_cloudwatch_log_delivery" "alb" {
  for_each                 = local.cloudwatch_log_types
  delivery_source_name     = aws_cloudwatch_log_delivery_source.alb[each.key].name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.alb[each.key].arn
  tags                     = var.tags

  # Resource policy must exist before any delivery is created, otherwise concurrent
  # deliveries race to auto-provision it and all but one fail with AccessDeniedException.
  depends_on = [aws_cloudwatch_log_resource_policy.alb]
}
