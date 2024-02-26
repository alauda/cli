# syntax=docker/dockerfile:1

FROM build-harbor.alauda.cn/ait/go-builder:1.18-alpine AS builder
ARG TARGETPLATFORM

# GO_LINKMODE defines if static or dynamic binary should be produced
ARG GO_LINKMODE=static
# GO_BUILDTAGS defines additional build tags
ARG GO_BUILDTAGS
# GO_STRIP strips debugging symbols if set
ARG GO_STRIP
# CGO_ENABLED manually sets if cgo is used
ARG CGO_ENABLED
# VERSION sets the version for the produced binary
ARG VERSION
WORKDIR /go/src/github.com/docker/cli
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 TARGET=/out ./scripts/build/binary && \
    CGO_ENABLED=0 GOOS=linux GOARCH=arm64 TARGET=/out ./scripts/build/binary && \
    echo "--static" /out/docker

FROM scratch AS binary
COPY --from=builder /out .
