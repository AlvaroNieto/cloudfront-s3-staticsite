resource "aws_cloudfront_distribution" "main-cloudfront" {
    enabled = true
    aliases = [ var.domain ]
    default_root_object = "index.html"
    is_ipv6_enabled = true
    wait_for_deployment = true
    price_class = "PriceClass_100"

    default_cache_behavior {
        allowed_methods   = [ "GET", "HEAD", "OPTIONS" ]
        cached_methods    = [ "GET", "HEAD", "OPTIONS" ]
        target_origin_id  = var.bucketname 
        cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        viewer_protocol_policy    = "redirect-to-https"
    }

    origin {
        domain_name   = "${var.bucketname}.s3.${var.regionname}.amazonaws.com" # Needed because .bucket_domain_name does not include the region.
        origin_id     = aws_s3_bucket.s3_staticsite.bucket
        origin_access_control_id = aws_cloudfront_origin_access_control.main-acl-cloudfront.id
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn = var.cert_arn
        minimum_protocol_version = "TLSv1.2_2021"
        ssl_support_method = "sni-only"
    }
}

resource "aws_cloudfront_origin_access_control" "main-acl-cloudfront" {
    name = "${var.domain}.accesslist"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"
}

data "aws_iam_policy_document" "cloudfront_oac" {
    statement {
        principals {
            identifiers = [ "cloudfront.amazonaws.com" ]
            type = "Service"
        }

        actions = [ "s3:GetObject" ]
        resources  = ["${aws_s3_bucket.s3_staticsite.arn}/*"]

        condition {
            test = "StringEquals"
            values = [ aws_cloudfront_distribution.main-cloudfront.arn ]
            variable = "AWS:SourceArn"
        }
    }
}