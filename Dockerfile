# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t automation_part .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name automation_part automation_part

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.4
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# 替换阿里源
RUN touch /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian stable main contrib non-free" > /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian stable-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian-security stable-security main contrib non-free" >> /etc/apt/sources.list

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

USER root

# 安装 Edge 和 chrome 所需的依赖库
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    vim \
    libglib2.0-0 \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libxss1 \
    libasound2 \
    libxtst6 \
    libgbm1 \
    libxshmfence1 \
    fonts-liberation \
    libvulkan1 \
    xdg-utils \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /tmp

# 安装 Microsoft Edge
RUN wget -q -O /tmp/microsoft-edge.deb https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_133.0.3065.92-1_amd64.deb \
    && apt-get install /tmp/microsoft-edge.deb

# 下载 Chrome
RUN wget https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.35/linux64/chrome-linux64.zip

# 解压 Chrome
RUN mkdir -p /opt \ 
    && unzip chrome-linux64.zip -d /opt/chrome \
    && mv /opt/chrome/chrome-linux64/chrome /usr/local/bin/chrome \
    && chmod +x /usr/local/bin/chrome

# 清理临时文件
RUN rm -rf /tmp/*

# Install packages needed to build gems
RUN apt-get update -qq && apt-get install -y \
    xvfb \
    xauth \
    x11-utils \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_23.x | bash - && \
    apt-get install -y nodejs

WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile




# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN npm install playwright@1.51.1
# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
# CMD ["xvfb-run", "./bin/thrust", "./bin/rails", "server"]
CMD ["bash", "-c", "xvfb-run --auto-servernum --server-args='-screen 0 1024x768x24' ./bin/thrust ./bin/rails server"]