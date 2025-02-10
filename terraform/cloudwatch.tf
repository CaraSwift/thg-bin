resource "aws_sns_topic" "ec2_alerts_topic" {
  name = "EC2AlertsTopic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.ec2_alerts_topic.arn
  protocol  = "email"
  endpoint  = "clswift1969@gmail.com"
}

# 🔹 High CPU Utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "High-CPU-Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_actions       = [aws_sns_topic.ec2_alerts_topic.arn]
  dimensions = {
    InstanceId = aws_instance.thgbin_instance.id
  }
}

# 🔹 Low Memory Availability
resource "aws_cloudwatch_metric_alarm" "low_memory" {
  alarm_name          = "Low-Memory-Usage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_available"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = 100000000  # 100MB
  alarm_actions       = [aws_sns_topic.ec2_alerts_topic.arn]
  dimensions = {
    InstanceId = aws_instance.thgbin_instance.id
  }
}

# 🔹 Low Disk Space
resource "aws_cloudwatch_metric_alarm" "low_disk_space" {
  alarm_name          = "Low-Disk-Space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_actions       = [aws_sns_topic.ec2_alerts_topic.arn]
  dimensions = {
    InstanceId = aws_instance.thgbin_instance.id
    path       = "/"
    device     = "xvda1"
    fstype     = "ext4"
  }
}

# 🔹 High Network Traffic
resource "aws_cloudwatch_metric_alarm" "high_network_in" {
  alarm_name          = "High-Network-In"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 50000000  # 50MB in 5 min
  alarm_actions       = [aws_sns_topic.ec2_alerts_topic.arn]
  dimensions = {
    InstanceId = aws_instance.thgbin_instance.id
  }
}

# 🔹 Docker Container Down (PrivateBin)
resource "aws_cloudwatch_metric_alarm" "docker_container_down" {
  alarm_name          = "PrivateBin-Container-Down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "docker_container_status"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.ec2_alerts_topic.arn]
  dimensions = {
    container_name = "privatebin"  
  }
}

# 🔹 Nginx 5xx Errors
resource "aws_cloudwatch_metric_alarm" "nginx_5xx_errors" {
  alarm_name          = "Nginx-5xx-Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Backend_5XX"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_actions       = [aws_sns_topic.ec2_alerts_topic.arn]
}

# 🔹 Failed SSH Login Attempts
resource "aws_cloudwatch_metric_alarm" "failed_ssh_logins" {
  alarm_name          = "Failed-SSH-Logins"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FailedLogins"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.ec2_alerts_topic.arn]
}

# 🔹 Unauthorized S3 Access
resource "aws_cloudwatch_metric_alarm" "unauthorized_s3_access" {
  alarm_name          = "Unauthorized-S3-Access"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "NumberOfObjects"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 100
  alarm_actions       = [aws_sns_topic.ec2_alerts_topic.arn]
}
