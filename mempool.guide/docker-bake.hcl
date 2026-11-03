variable "RUNNER_ARCH" {
  type = string
  default = "X64"
  description = "The architecture of the runner executing the job"
  validation {
    condition = contains(["ARM64", "X64"], RUNNER_ARCH)
    error_message = "Invalid value for 'RUNNER_ARCH' variable"
  }
}

target "mempool-guide-backend" {
  context = "mempool.guide/backend"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/mempool.guide:backend-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/mempool.guide:backend-${RUNNER_ARCH}"]
}

target "mempool-guide-frontend" {
  context = "mempool.guide/frontend"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/mempool.guide:frontend-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/mempool.guide:frontend-${RUNNER_ARCH}"]
}
