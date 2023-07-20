## LAUNCH TEMPLATE ##
resource "aws_launch_template" "lt" {

  name_prefix   = "${var.env}_KPMG"
  key_name      = var.lt_keypair_admin
  image_id      = var.lt_ami
  instance_type = var.lt_instance_type

  iam_instance_profile {
    arn = var.lt_iam_instance_profile_arn
  }
  ebs_optimized = true

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_type           = "gp3"
      volume_size           = var.lt_ebs_volume_size
      delete_on_termination = true
    }
  }

  vpc_security_group_ids = [var.lt_securitygroup_id]
  user_data = file("../../Template/${var.os}/ngnix.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.lt_tag_name == null ? "${var.env}_KPMG" : var.lt_tag_name
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name = var.lt_tag_name == null ? "${var.env}_KPMG" : var.lt_tag_name
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


## AUTOSCALING GROUP ##

resource "aws_autoscaling_group" "asg" {
  name                = "${var.env}_KPMG"
  target_group_arns   = var.asg_lb_target_group_arn != null ? [var.asg_lb_target_group_arn] : []
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = var.asg_vpc_zone_identifier
  enabled_metrics     = var.asg_enabled_metrics

  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }

  health_check_type         = var.asg_lb_target_group_arn != null ? "ELB" : "EC2"
  health_check_grace_period = var.asg_lb_target_group_arn != null ? var.asg_health_check_grace_period : null

  # Static tags
  tag {
    key = "Name"
    value               = var.lt_tag_name == null ? "${var.env}_KPMG" : var.lt_tag_name
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.env
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.asg_lb_target_group_arn != null ? [var.asg_lb_target_group_arn] : []

    content {
      key                 = "targetgroup"
      value               = tag.value
      propagate_at_launch = true
    }
  }

  # Additional tags as defined by parameter input
  dynamic "tag" {
    for_each = var.asg_additional_tags

    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
  }
}

## AUTOSCALING NOTIFICATION ##

resource "aws_autoscaling_notification" "asg_notification" {
  group_names = [aws_autoscaling_group.asg.name]

  notifications = concat(
    var.notifications_additional, [
      "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
      "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
    ]
  )

  topic_arn = var.notification_topic_arn
}

