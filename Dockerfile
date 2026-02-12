# Imagem base do Cypress (já vem com Node e forcei a versao)
FROM cypress/base:20.17.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Variáveis úteis
ENV HUSKY=0 \
    DISPLAY=:99 \
    CHROME_FLAGS="--no-sandbox --disable-gpu" \
    CYPRESS_CACHE_FOLDER=/root/.cache/Cypress

RUN   apt-get update \
      && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      gnupg \
      wget \
      default-jdk \
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
      libgconf-2-4

# Dependências do SO + Chrome + Java (tudo em um RUN para reduzir layers)
RUN   install -m 0755 -d /etc/apt/keyrings \
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
      # Chrome
      google-chrome-stable \
      # k6
      k6 \
      # limpeza
      && rm -rf /var/lib/apt/lists/*

# Azure CLI + kubectl (aks install-cli)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
  && az aks install-cli

# Allure (global)
RUN npm install -g allure-commandline

# Home
WORKDIR /home/cypress

COPY . .

RUN npm ci

# Garante binário do Cypress no build
RUN npx --no-install cypress verify || npx cypress install

RUN chmod +x /home/cypress/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]