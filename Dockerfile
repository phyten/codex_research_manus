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

# 追加でtcolorbox関連のパッケージを確実にインストール
RUN apt-get update && apt-get install -y \
    texlive-latex-extra \
    && rm -rf /var/lib/apt/lists/*

# 日本語フォントのインストール
RUN apt-get update && apt-get install -y \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fonts-takao \
    fonts-vlgothic \
    && rm -rf /var/lib/apt/lists/*

# フォントキャッシュの更新
RUN fc-cache -fv

# 利用可能な日本語フォントを確認
RUN fc-list | grep -E "(Noto|Takao|VL)" | head -10

# 作業ディレクトリの設定
WORKDIR /workspace

# デフォルトコマンド
CMD ["pandoc", "--version"] 