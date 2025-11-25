# 使用更小的 slim 版本作为基础镜像
FROM rust:slim-trixie

# 将所有系统依赖安装和清理操作合并到一条 RUN 指令中
# --no-install-recommends 可以避免安装非必需的推荐包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    clang-19 \
    llvm-19 \
    libclang-19-dev \
    libz-dev && \
    rm -rf /var/lib/apt/lists/*

# 将 rustup 和 cargo 操作合并，并在完成后清理缓存
RUN rustup toolchain install nightly --component rust-src && \
    rustup default nightly && \
    cargo install bpf-linker && \
    # 清理下载的工具链和 cargo 缓存，能节省大量空间
    rm -rf /root/.rustup/toolchains/* && \
    rm -rf /root/.cargo/registry/* /root/.cargo/git/*
