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

variable "PHP_MAJOR" {
  type = string
  default = format("%s.%s", split(".", VERSION)[0], split(".", VERSION)[1])
  description = "Major software version for caching tags (1maa/php only)"
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

target "php-86" {
  args = {
    PHP_VERSION = "8.6.0RC7"
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
