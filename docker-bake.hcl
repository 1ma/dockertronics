variable "VERSION" {
  type = string
  default = "0.0.0"
  description = "Version of the software to build"
}

variable "RUNNER" {
  type = string
  default = "ubuntu-24.04"
  description = "Runner that built the image"
}

target "beanstalkd" {
  context = "beanstalkd"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/beanstalkd:latest"
  }]
  tags = ["1maa/beanstalkd:latest"]
}

target "cln-alpine" {
  context = "core-lightning"
  dockerfile = "alpine/Dockerfile"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/core-lightning:alpine"
  }]
  tags = [
    "1maa/core-lightning:alpine",
    "1maa/core-lightning:latest"
  ]
}

target "cln-debian" {
  context = "core-lightning"
  dockerfile = "debian/Dockerfile"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/core-lightning:debian"
  }]
  tags = ["1maa/core-lightning:debian"]
}

target "electrs" {
  context = "electrs"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/electrs:latest"
  }]
  tags = ["1maa/electrs:latest"]
}

target "erlang" {
  args = {
    ERLANG_VERSION = "${VERSION}"
  }
  context = "erlang"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/erlang:${VERSION}-${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/erlang:${VERSION}-${RUNNER}"]
}

target "haproxy" {
  context = "haproxy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/haproxy:3.2"
  }]
  tags = [
    "1maa/haproxy:3.2",
    "1maa/haproxy:latest"
  ]
}

target "lua" {
  context = "lua"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/lua:5.4"
  }]
  tags = ["1maa/lua:5.4"]
}

target "postgres" {
  args = {
    POSTGRES_VERSION = "${VERSION}"
  }
  context = "postgres"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/postgres:${VERSION}-${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/postgres:${VERSION}-${RUNNER}"]
}

target "protoc" {
  context = "protoc"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/protoc:latest"
  }]
  tags = ["1maa/protoc:latest"]
}

target "selfsig" {
  context = "selfsig"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/selfsig:latest"
  }]
  tags = ["1maa/selfsig:latest"]
}

target "sftp" {
  context = "sftp"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/sftp:latest"
  }]
  tags = ["1maa/sftp:latest"]
}

target "sleepy" {
  context = "sleepy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/sleepy:latest"
  }]
  tags = ["1maa/sleepy:latest"]
}

target "sqlite" {
  context = "sqlite"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/sqlite:${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/sqlite:${RUNNER}"]
}
