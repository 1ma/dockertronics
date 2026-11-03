variable "RUNNER_ARCH" {
  type = string
  default = "X64"
  description = "The architecture of the runner executing the job"
  validation {
    condition = contains(["ARM64", "X64"], RUNNER_ARCH)
    error_message = "Invalid value for 'RUNNER_ARCH' variable"
  }
}

target "haproxy" {
  context = "haproxy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/haproxy:latest-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/haproxy:latest-${RUNNER_ARCH}"]
}
