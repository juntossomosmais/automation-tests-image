# Cypress Docker Image with Allure Report

Este repositório contém um Dockerfile que cria uma imagem Docker, configurada para executar testes Cypress com relatórios do Allure. 

## Funcionalidades

- Baseada em **Cypress/latest**
- Instalação do **Allure Commandline** para geração de relatórios
- Configurada para executar um script personalizado `entrypoint.sh` ao iniciar o contêiner

## Pré-requisitos

- Docker instalado no sistema

## Como construir a imagem

Para construir a imagem Docker, utilize o seguinte comando no diretório onde o Dockerfile está localizado:

docker build -t cypress-allure-image .


## Como executar o contêiner

Uma vez que a imagem esteja construída, você pode executar o contêiner com o seguinte comando:


docker run -it -p 8080:8080 cypress-allure-image


O contêiner expõe a porta 8080, que pode ser mapeada para a máquina host. Certifique-se de que o entrypoint.sh está configurado corretamente para iniciar a aplicação ou testes desejados.

## Estrutura do projeto

	•	Dockerfile: Define as instruções para construir a imagem.
	•	entrypoint.sh: Script de entrada personalizado que será executado quando o contêiner iniciar.
	•	app/: Diretório de exemplo que pode conter os arquivos do seu proje
    to.

## Instalações Incluídas

	•	Java (default-jdk)
	•	Allure Commandline (instalado globalmente via npm)
	•	Outras dependências: curl, vim, git, Chrome



## Comandos Úteis

	•	Verificar versão do Node.js: node --version
	•	Verificar versão do npm: npm --version
	•	Verificar versão do Cypress: npx cypress version
	•	Instalar dependências do projeto: npm install
	•	Executar testes com Cypress: npx cypress run
	•	Gerar relatórios com Allure: allure generate

## Personalização

Você pode modificar o entrypoint.sh para executar diferentes comandos ou scripts no início da execução do contêiner, de acordo com as necessidades do seu projeto.

## Autor

Este Dockerfile foi criado por [Juntos Somos Mais] 

## Licença

Este projeto está licenciado sob a MIT License.

Este `README.md` fornece uma visão geral do projeto, explicando como construir e executar o contêiner, bem como descrevendo as instalações e dependências incluídas. Certifique-se de ajustar as instruções conforme necessário para atender às necessidades específicas do seu projeto.