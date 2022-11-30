# Create ACM Cert.

# If you wish to enable SSL/TLS with an AWS ACM Certificate then uncomment the below, to create a cert for your domain:

#resource "aws_acm_certificate" "cert" {
#  domain_name       = var.root_domain_name
#  validation_method = "DNS"
#  lifecycle {
#    create_before_destroy = true
#  }
#}

# Valadate the cert against the domain you purchased.

#resource "aws_acm_certificate_validation" "cert" {
#  certificate_arn = aws_acm_certificate.cert.arn
#  validation_record_fqdns = [aws_route53_record.cert_dns.fqdn]
#}
