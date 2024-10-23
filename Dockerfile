# Use a imagem base oficial do Cypress
FROM cypress/base:latest

# Atualizar o repositório de pacotes e instalar pacotes necessários
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    git \
    default-jdk

# Instalar o Node.js    
RUN node --version
RUN npm --version    

# Exibe a versão do Java
RUN java -version 

# Instalar o Google Chrome
# Definir variáveis de ambiente para evitar prompts interativos
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza a lista de pacotes e instala dependências necessárias
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates

# Adiciona a chave GPG do Google Chrome e o repositório
RUN wget -q -O /usr/share/keyrings/google-chrome-keyring.gpg https://dl.google.com/linux/linux_signing_key.pub \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list

# Atualiza a lista de pacotes novamente e instala o Google Chrome
RUN apt-get update && apt-get install -y google-chrome-stable

# Limpeza para reduzir o tamanho da imagem
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Definir o comando padrão para a imagem (opcional, depende do uso do Chrome)
CMD ["google-chrome", "--version"]

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

