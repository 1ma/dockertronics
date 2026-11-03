target "protoc" {
  context = "protoc"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/protoc:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/protoc:latest"]
}
