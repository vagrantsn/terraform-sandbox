data "local_file" "build_spec" {
  filename = "${path.module}/build.yml"
}

resource "aws_amplify_app" "nextjs" {
  name       = "nextjs-example-app"
  build_spec = data.local_file.build_spec.content
}
