# tazdingo_buildenv
#
# 这个镜像被设计为一个通用的 Rust 构建环境，特别配置用于构建
# 支持 x86_64 和 aarch64 架构的静态链接二进制文件 (musl)。

# 使用更小的 slim 版本作为基础镜像
FROM rust:slim-trixie

# 1. 安装构建依赖
#    - musl-tools: 用于 musl 静态链接
#    - clang/llvm: bpf-linker 等工具可能需要
#    - libz-dev: 常见的压缩库依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    musl-tools \
    clang-19 \
    llvm-19 \
    libclang-19-dev \
    libz-dev && \
    # 清理 apt 缓存以减小镜像体积
    rm -rf /var/lib/apt/lists/*

# 2. 配置 Rust 工具链
#    - 安装 nightly 工具链和 rust-src 组件
#    - 安装 bpf-linker
#    - 添加 x86_64 和 aarch64 的 musl 目标
RUN rustup toolchain install nightly --component rust-src && \
    rustup default nightly && \
    cargo install bpf-linker && \
    rustup target add x86_64-unknown-linux-musl && \
    rustup target add aarch64-unknown-linux-musl