variable "RUNNER" {
  type = string
  default = "ubuntu-24.04"
  description = "Runner that built the image"
}

variable "VERSION" {
  type = string
  default = "0.0.0"
  description = "Version of the software to build"
}

variable "VERSION_MAJOR" {
  type = string
  default = split(".", VERSION)[0]
  description = "Major software version for caching tags"
}

variable "PHP_MAJOR" {
  type = string
  default = format("%s.%s", split(".", VERSION)[0], split(".", VERSION)[1])
  description = "Major software version for caching tags (1maa/php only)"
}

group "default" {
  description = "Dependency-free images that can be easily built concurrently"
  targets = [
    "haproxy",
    "lnd",
    "protoc",
    "selfsig",
    "sftp",
    "sleepy"
  ]
}

group "rust-build" {
  description = "Images involving cumbersome Rust builds"
  targets = [
    "cln-alpine",
    "cln-debian",
    "electrs",
    "mempool-guide-backend",
    "mempool-guide-frontend"
  ]
}

target "cln-alpine" {
  args = {
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
    PUBLIC_GOLANG_IMAGE = "sha256:2389ebfa5b7f43eeafbd6be0c3700cc46690ef842ad962f6c5bd6be49ed82039" # :alpine
  }
  context = "core-lightning"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/core-lightning:alpine"
  }]
  dockerfile = "alpine/Dockerfile"
  tags = [
    "1maa/core-lightning:alpine",
    "1maa/core-lightning:latest"
  ]
}

target "cln-debian" {
  args = {
    PUBLIC_DEBIAN_IMAGE = "sha256:26f98ccd92fd0a44d6928ce8ff8f4921b4d2f535bfa07555ee5d18f61429cf0c" # :trixie-slim
    PUBLIC_GOLANG_IMAGE = "sha256:ce3f1c8d3718a306811d8d5e547073b466b15e85bfa7e1b4f0dc45516c95b72d" # :trixie
  }
  context = "core-lightning"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/core-lightning:debian"
  }]
  dockerfile = "debian/Dockerfile"
  tags = ["1maa/core-lightning:debian"]
}

target "electrs" {
  args = {
    PUBLIC_DEBIAN_IMAGE = "sha256:26f98ccd92fd0a44d6928ce8ff8f4921b4d2f535bfa07555ee5d18f61429cf0c" # :trixie-slim
  }
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
    ERLANG_VERSION = VERSION
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
  }
  context = "erlang"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/erlang:${VERSION_MAJOR}-${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/erlang:${VERSION_MAJOR}-${RUNNER}"]
}

target "haproxy" {
  args = {
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
  }
  context = "haproxy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/haproxy:3.2"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = [
    "1maa/haproxy:3.2",
    "1maa/haproxy:latest"
  ]
}

target "lnd" {
  args = {
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
    PUBLIC_GOLANG_IMAGE = "sha256:2389ebfa5b7f43eeafbd6be0c3700cc46690ef842ad962f6c5bd6be49ed82039" # :alpine
  }
  context = "lnd"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/lnd:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/lnd:latest"]
}

target "mempool-guide-backend" {
  args = {
    PUBLIC_NODE_IMAGE = "sha256:cf38e1f3c28ac9d81cdc0c51d8220320b3b618780e44ef96a39f76f7dbfef023" # :25-alpine
  }
  context = "mempool.guide/backend"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/mempool.guide:backend"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/mempool.guide:backend"]
}

target "mempool-guide-frontend" {
  args = {
    PUBLIC_CADDY_IMAGE = "sha256:fce4f15aad23222c0ac78a1220adf63bae7b94355d5ea28eee53910624acedfa" # :alpine
    PUBLIC_NODE_IMAGE = "sha256:cf38e1f3c28ac9d81cdc0c51d8220320b3b618780e44ef96a39f76f7dbfef023" # :25-alpine
  }
  context = "mempool.guide/frontend"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/mempool.guide:frontend"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/mempool.guide:frontend"]
}

target "php" {
  args = {
    PHP_VERSION = VERSION
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
  }
  context = "php"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/php:${PHP_MAJOR}-${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/php:${PHP_MAJOR}-${RUNNER}"]
}

target "postgres" {
  args = {
    POSTGRES_VERSION = VERSION
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
  }
  context = "postgres"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/postgres:${VERSION_MAJOR}-${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/postgres:${VERSION_MAJOR}-${RUNNER}"]
}

target "protoc" {
  args = {
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
    PUBLIC_GOLANG_IMAGE = "sha256:2389ebfa5b7f43eeafbd6be0c3700cc46690ef842ad962f6c5bd6be49ed82039" # :alpine
  }
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
  args = {
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
  }
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
  args = {
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
  }
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
  args = {
    PUBLIC_GOLANG_IMAGE = "sha256:2389ebfa5b7f43eeafbd6be0c3700cc46690ef842ad962f6c5bd6be49ed82039" # :alpine
  }
  context = "sleepy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/sleepy:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/sleepy:latest"]
}

target "sqlite" {
  args = {
    PUBLIC_ALPINE_IMAGE = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659" # :3.23
  }
  context = "sqlite"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/sqlite:${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/sqlite:${RUNNER}"]
}
