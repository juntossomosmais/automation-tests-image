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



#Instala dependencias do cypress

# Instala globalmente o allure-commandline
RUN npm install -g allure-commandline 


# Baixa e instala o binário do Cypress
RUN npx cypress install


# Browserlist
RUN npx browserslist@latest

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /usr/src/app

# Expor uma porta (se o contêiner for servir uma aplicação)
EXPOSE 8080



# Script para personlizar comandos 
 ENTRYPOINT ["./entrypoint.sh", "npx", "cypress", "run"]
