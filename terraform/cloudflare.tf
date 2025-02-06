provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "app" {
  zone_id = var.cloudflare_zone_id
  name    = "app"
  value   = aws_instance.privatebin.public_ip  # Uses EC2's public IP
  type    = "A"
  ttl     = 300
  proxied = true  # Enable Cloudflare Proxy
}