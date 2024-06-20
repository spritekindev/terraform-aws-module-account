############################################################################################
# Service linked roles
# A list of service linked roles is passed in the paremeters. i.e.
# { spot = "spot.amazonaws.com" }
resource "aws_iam_service_linked_role" "service_linked_role" {
  for_each = var.service_linked_role
  aws_service_name = each.value
  description      = "${each.value} Service-Linked Role"
}
