variable "env" {
  type        = string
}
# launch template variables
variable "lt_ami" {
  type        = string
}
variable "lt_keypair_admin" {
  type        = string
}
variable "lt_instance_type" {
  type        = string
}
variable "lt_iam_instance_profile_arn" {
  type        = string
}
variable "lt_securitygroup_id" {
  type        = string
}
variable "lt_user_data" {
  type        = string
}
variable "lt_ebs_volume_size" {
  type        = number
  default     = 30
}
variable "lt_tag_name" {
  type        = string
  default     = null
}

# autoscaling group variables
variable "asg_vpc_zone_identifier" {
  type        = list(string)
}
variable "asg_max_size" {
  type        = number
  default     = 1
}
variable "asg_min_size" {
  type        = number
  default     = 0
}
variable "asg_desired_capacity" {
  type        = number
  default     = 1
}
variable "asg_name" {
  type        = string
  default     = null
}
variable "asg_enabled_metrics" {
  type        = list(string)
  default     = []
}
variable "asg_lb_target_group_arn" {
  type        = string
  default     = null
}
variable "asg_health_check_grace_period" {
  type        = number
  default     = 300
}
variable "asg_additional_tags" {
  description = "Optional, additional tags to be added to the ASG"
  type = list(
    object({
      key                 = string
      value               = string
      propagate_at_launch = bool
    })
  )
  default = []
}

variable "os" {
  type = string
}

# autoscaling notification variables
variable "notification_topic_arn" {
  description = "The ARN of the SNS topic for autoscaling notifications"
  type        = string
}


