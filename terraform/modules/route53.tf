#Create subdomain in Route53
resource "aws_route53_record" "domain-main" {
    name = var.domain
    type = "A"
    zone_id = var.hosted_zone_id
    #zone_id = var.hosted_zone_id

    alias {
        name    = aws_cloudfront_distribution.main-cloudfront.domain_name
        zone_id = aws_cloudfront_distribution.main-cloudfront.hosted_zone_id
        evaluate_target_health = false
    }
}