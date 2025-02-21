# ARG BUILDPLATFORM="linux/amd64"
ARG BUILDERIMAGE="golang:1.23.4"
# ARG BASEIMAGE="gcr.io/distroless/static:nonroot"
ARG BASEIMAGE="cgr.dev/chainguard/static:latest-glibc"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        # FROM --platform=$BUILDPLATFORM $BUILDERIMAGE as builder
FROM $BUILDERIMAGE as builder

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG LDFLAGS

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o justtrustme .

FROM $BASEIMAGE

WORKDIR /app

COPY --from=builder /app .

USER 65532:65532

ENTRYPOINT ["/app/justtrustme"]
