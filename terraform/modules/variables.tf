#Common variables

variable "domain" {
  description = "Domain or subdomain to use in the deployment. It must exist beforehand"
  type        = string
}

variable "hosted_zone_id" {
  description = "Domain hosted zone id"
  type        = string
  sensitive   = true
}

#Storage variables

variable "bucketname" {
  description = "Name for the bucket"
  type        = string
}

variable "bucket_tags" {
  description = "Tag definition for the bucket"
  type = map(string)
}

variable "html_path" {
  description = "Path to the HTML files"
  type        = string
}

variable "cert_arn" {
  description = "Generated certificated in ACM"
  type        = string
  sensitive   = true
}

#Cloudfront variables

variable "regionname" {
  description = "Region"
  type        = string
}