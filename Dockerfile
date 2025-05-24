# syntax=docker/dockerfile:1
FROM ubuntu:22.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# 基本パッケージのインストール（軽量、キャッシュ効率良）
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    fontconfig

# TeXLive段階（最も時間がかかる部分）
FROM base AS texlive
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    texlive-full \
    pandoc

# 追加でtcolorbox関連のパッケージを確実にインストール
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    texlive-latex-extra

# 日本語フォント段階
FROM texlive AS fonts
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fonts-takao \
    fonts-vlgothic

# 最終段階
FROM fonts AS final

# フォントキャッシュの更新
RUN fc-cache -fv

# 利用可能な日本語フォントを確認
RUN fc-list | grep -E "(Noto|Takao|VL)" | head -10

# 作業ディレクトリの設定
WORKDIR /workspace

# デフォルトコマンド
CMD ["pandoc", "--version"] 