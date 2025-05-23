FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 基本パッケージのインストール
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    fontconfig \
    && rm -rf /var/lib/apt/lists/*

# TeXLiveとPandocのインストール
RUN apt-get update && apt-get install -y \
    texlive-full \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# フォントキャッシュの更新
RUN fc-cache -fv

# 作業ディレクトリの設定
WORKDIR /workspace

# デフォルトコマンド
CMD ["pandoc", "--version"] 