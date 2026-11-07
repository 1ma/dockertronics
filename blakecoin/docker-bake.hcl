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

target "blakecoin" {
  args = {
    KNOTS_VERSION = VERSION
  }
  context = "blakecoin"
  cache-to = [{ type = "inline" }]
  cache-from = [
    {
      type = "registry"
      ref  = "ghcr.io/1ma/blakecoin:v${VERSION}-${RUNNER_ARCH}"
    }
  ]
  tags = ["ghcr.io/1ma/blakecoin:v${VERSION}-${RUNNER_ARCH}"]
}

target "blakecoin-miner" {
  context = "blakecoin"
  cache-to = [{ type = "inline" }]
  cache-from = [
    {
      type = "registry"
      ref  = "1maa/blakecoin:signet-miner"
    }
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/blakecoin:signet-miner"]
  target = "signet-miner"
}
