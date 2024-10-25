# Use a imagem base oficial do Cypress
FROM cypress/base:latest

# Atualizar o repositório de pacotes e instalar pacotes necessários
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    git \
    default-jdk

# Atualizar os pacotes existentes e instalar as dependências necessárias
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    ca-certificates \
    --no-install-recommends


# Baixar e instalar o repositório do Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable --no-install-recommends

RUN apt-get update && \
    apt-get install -y \
    libgtk2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libnotify-dev \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xauth \
    xvfb \
    && apt-get clean   

# Limpar cache do apt-get para reduzir o tamanho da imagem
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Verificar se o Google Chrome foi instalado corretamente
RUN google-chrome --version  

# Instalar o Node.js    
RUN node --version
RUN npm --version    

# Exibe a versão do Java
RUN java -version 

#Instala dependências necessárias
RUN apt-get update && apt-get install -y \
    libxi6 \
    libgconf-2-4 \
    libgtk-3-0 \
    google-chrome-stable
#Define variáveis de ambiente
ENV DISPLAY=:99
ENV CHROME_FLAGS "--no-sandbox --disable-gpu"


# Instalar dependências do Cypress

# Instalar globalmente o allure-commandline
RUN npm install -g allure-commandline 

# Baixar e instalar o binário do Cypress
RUN npx cypress install

# Browserlist
RUN npx browserslist@latest

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /usr/src/app

# Expor uma porta (se o contêiner for servir uma aplicação)
EXPOSE 8080

# Script para personalizar comandos 
ENTRYPOINT ["./entrypoint.sh", "npx", "cypress", "run"]