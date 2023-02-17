variable "instance_name" {
  description = "Value of the Name tag for the EC instance"
  type        = string
  default     = "InstanciaTerraform"
}
variable "instance_app_name" {
  description = "Value of the APP tag for the EC instance"
  type        = string
  default     = "vue2048"
}
variable "instance_count" {
  description = "Creating n similar EC2 instances"
  type        = number
  default     = 1
}
