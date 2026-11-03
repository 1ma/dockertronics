group "default" {
  description = "Dependency-free images that can be easily built concurrently"
  targets = [
    "frigate",
    "lnd",
    "protoc",
    "selfsig",
    "sftp",
    "sleepy"
  ]
}

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

target "lnd" {
  context = "lnd"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/lnd:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/lnd:latest"]
}

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

target "sftp" {
  context = "sftp"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/sftp:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/sftp:latest"]
}

target "sleepy" {
  context = "sleepy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/sleepy:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/sleepy:latest"]
}
