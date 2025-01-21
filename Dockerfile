# 使用官方的 Go 镜像作为构建环境
FROM --platform=$BUILDPLATFORM golang:1.20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制 go.mod 和 go.sum 文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制项目文件
COPY . .

# 构建项目
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -o server .

# 使用轻量级的 Alpine 镜像作为运行环境
FROM alpine:latest

# 设置工作目录
WORKDIR /root/

# 从构建阶段复制可执行文件
COPY --from=builder /app/server .

# 暴露端口（根据项目需求修改）
EXPOSE 9998
EXPOSE 9999

# 运行应用程序
CMD ["./server"]
