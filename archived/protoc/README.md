> [!WARNING]
> **This image is archived.** It is no longer built or published, and the existing tags on Docker Hub
> will not receive any updates. It was retired on 2026-11-07 because it was no longer needed.
> The files are kept here for reference only and may not build anymore.

# 1maa/protoc:latest

Alpine image with all the necessary tools to compile [gRPC](https://grpc.io/) service definitions into Go source code, namely:

- Google's "well known" protobuf types (`any.proto`, `empty.proto` etc.)
- `protoc` executable
- `protoc-gen-go` plugin for `protoc`
- `protoc-gen-go-grpc` plugin for `protoc`
