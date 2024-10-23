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
USER root
RUN apt-get install -y wget
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub &&  \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable

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

