resource "aws_ssm_patch_group" "this" {
  patch_group = var.patch_group
  baseline_id = aws_ssm_patch_baseline.this.id
}
