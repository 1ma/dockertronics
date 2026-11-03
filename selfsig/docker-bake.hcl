target "selfsig" {
  context = "selfsig"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/selfsig:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/selfsig:latest"]
}
