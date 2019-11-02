resource "aws_guardduty_detector" "IDS" {
  enable = true
  finding_publishing_frequency = "SIX_HOURS"
}