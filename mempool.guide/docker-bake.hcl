variable "RUNNER_ARCH" {
  type = string
  default = "X64"
  description = "The architecture of the runner executing the job"
  validation {
    condition = contains(["ARM64", "X64"], RUNNER_ARCH)
    error_message = "Invalid value for 'RUNNER_ARCH' variable"
  }
}

variable "MEMPOOL_BRANCH" {
  type    = string
  default = "master"
  validation {
    condition = contains(["master", "poolcoin"], MEMPOOL_BRANCH)
    error_message = "Invalid value for 'MEMPOOL_BRANCH' variable"
  }
}

target "mempool-guide-backend" {
  context = "mempool.guide/backend"
  args = {
    MEMPOOL_BRANCH = MEMPOOL_BRANCH
  }
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/mempool.guide:${MEMPOOL_BRANCH}-backend-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/mempool.guide:${MEMPOOL_BRANCH}-backend-${RUNNER_ARCH}"]
}

target "mempool-guide-frontend" {
  context = "mempool.guide/frontend"
  args = {
    MEMPOOL_BRANCH = MEMPOOL_BRANCH
  }
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/mempool.guide:${MEMPOOL_BRANCH}-frontend-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/mempool.guide:${MEMPOOL_BRANCH}-frontend-${RUNNER_ARCH}"]
}
