# Imagem base do Cypress (Node já incluso) ... versão fixada
FROM cypress/base:20.17.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Variáveis úteis
ENV HUSKY=0 \
    DISPLAY=:99 \
    CHROME_FLAGS="--no-sandbox --disable-gpu" \
    CYPRESS_CACHE_FOLDER=/root/.cache/Cypress

# Dependências do SO + Chrome + Java + k6 (tudo em um RUN para reduzir layers)
RUN install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor -o /etc/apt/keyrings/google-linux.gpg \
  && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list \
  && curl -fsSL https://dl.k6.io/key.gpg \
    | gpg --dearmor -o /etc/apt/keyrings/k6.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/k6.gpg] https://dl.k6.io/deb stable main" \
    > /etc/apt/sources.list.d/k6.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    wget \
    default-jdk \
    unzip \
    # libs comuns para Chrome/Cypress em headless
    xvfb \
    xauth \
    libgtk-3-0 \
    libgbm1 \
    libnotify4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    libxi6 \
    libgconf-2-4 \
    # Chrome
    google-chrome-stable \
    # k6
    k6 \
  && rm -rf /var/lib/apt/lists/*

# Azure CLI + kubectl (aks install-cli)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
  && az aks install-cli

# kubelogin (instalação explícita para não depender do install-cli)
ARG KUBELOGIN_VERSION=v0.1.6
RUN set -euo pipefail \
  && ARCH="$(dpkg --print-architecture)" \
  && case "$ARCH" in \
       amd64) KARCH="amd64" ;; \
       arm64) KARCH="arm64" ;; \
       *) echo "Arquitetura não suportada: $ARCH" >&2; exit 1 ;; \
     esac \
  && curl -fsSL -o /tmp/kubelogin.zip \
     "https://github.com/Azure/kubelogin/releases/download/${KUBELOGIN_VERSION}/kubelogin-linux-${KARCH}.zip" \
  && unzip -q /tmp/kubelogin.zip -d /tmp/kubelogin \
  && install -m 0755 /tmp/kubelogin/bin/linux_${KARCH}/kubelogin /usr/local/bin/kubelogin \
  && kubelogin --version \
  && rm -rf /tmp/kubelogin /tmp/kubelogin.zip \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Allure (global)
RUN npm install -g allure-commandline

# Home
WORKDIR /home/cypress

# Runner model: não copiamos o repo e não rodamos npm ci aqui,
# pois o docker-compose monta o workspace via volume (./:/home/cypress)
# e o entrypoint.sh executa npm ci em runtime.

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]