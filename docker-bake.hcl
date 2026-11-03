variable "RUNNER_ARCH" {
  type = string
  default = "X64"
  description = "The architecture of the runner executing the job"
  validation {
    condition = contains(["ARM64", "X64"], RUNNER_ARCH)
    error_message = "Invalid value for 'RUNNER_ARCH' variable"
  }
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

target "php-86" {
  args = {
    PHP_VERSION = "8.6.0RC4"
  }
  context = "php"
  dockerfile = "Dockerfile.86"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/php:8.6-RC"
  }]
  tags = ["1maa/php:8.6-RC"]
}

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

target "php" {
  args = {
    PHP_VERSION = VERSION
  }
  context = "php"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/php:${PHP_MAJOR}-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/php:${PHP_MAJOR}-${RUNNER_ARCH}"]
}

target "postgres" {
  args = {
    POSTGRES_VERSION = VERSION
  }
  context = "postgres"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/postgres:${VERSION_MAJOR}-alpine-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/postgres:${VERSION_MAJOR}-alpine-${RUNNER_ARCH}"]
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
