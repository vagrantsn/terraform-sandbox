data "local_file" "build_spec" {
  filename = "${path.module}/build.yml"
}

resource "aws_amplify_app" "app" {
  name       = "nextjs-example-app"
  repository = "https://github.com/vagrantsn/terraform-sandbox"
  build_spec = data.local_file.build_spec.content
  platform   = "WEB_COMPUTE"

  access_token = var.access_token
}

resource "aws_amplify_branch" "production" {
  app_id      = aws_amplify_app.app.id
  branch_name = "nextjs"

  framework = "Next.js - SSR"
  stage     = "PRODUCTION"
}
