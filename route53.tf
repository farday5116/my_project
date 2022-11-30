# If you wish to enable HTTPS using AWS ACM, then uncomment the below, to create the Route 53 resources, for your domain.
# Please note that you will have to have an already registered domain, and either added it to AWS Route 53, or purchased it from AWS Route 53.

# Create Route 53 Hosted Zone.

#resource "aws_route53_zone" "route53_zone" {
#  name = var.root_domain_name
#}

# Create Record Sets.

#resource "aws_route53_record" "cert_dns" {
#  allow_overwrite = true
#  name =  tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
#  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
#  type = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
#  zone_id = aws_route53_zone.route53_zone.zone_id
#  ttl = 60
#}

#resource "aws_route53_record" "alb" {
#  zone_id = aws_route53_zone.route53_zone.zone_id
#  name    = "${var.app}.${var.root_domain_name}"
#  type    = "CNAME"
#  ttl     = "60"
#  records = [aws_lb.app.dns_name]
#}