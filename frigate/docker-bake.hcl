target "frigate" {
  context = "frigate"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/frigate:latest"
  }]
  tags = [
    "1maa/frigate:latest"
  ]
}
