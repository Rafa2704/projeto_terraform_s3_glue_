# Projeto de Engenharia de Dados com Terraform

Este projeto utiliza o Terraform para provisionar uma infraestrutura de engenharia de dados na AWS. O projeto inclui a criação de um bucket S3, carregamento de dados, configuração do AWS Glue para catalogação de dados, e a criação de uma função IAM para o Glue.

## Estrutura do Projeto

- **Provedor AWS**: Configurado usando uma variável de região.
- **Sufixo Aleatório**: Gerado para o nome do bucket S3.
- **Bucket S3**: Criado com um nome composto de um prefixo e o sufixo aleatório.
- **Carregamento de Dados**: Um arquivo CSV é carregado no bucket S3.
- **Função IAM**: Criada para o serviço AWS Glue.
- **Política IAM**: Associada à função IAM, concedendo as permissões necessárias para o Glue.
- **Banco de Dados no Glue**: Criado no catálogo do Glue.
- **Crawler do Glue**: Configurado para catalogar os dados no bucket S3.
- **Exportação**: O nome do bucket S3 é exportado como saída.

## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado
- Conta AWS com permissões adequadas
- Configuração do AWS CLI com credenciais válidas

## Uso

1. **Clone o Repositório**

   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
   cd seu-repositorio

2. **Inicialize o Terraform**
   terraform init
  
3. **Planeje a Infraestrutura**
   terraform plan

4. **Aplique o Plano**
   terraform apply

## Estrutura de Arquivos

- **main.tf**: Arquivo principal com a configuração do Terraform.
- **variables.tf**: Definição de variáveis utilizadas no projeto.
- **outputs.tf**: Definição das saídas do projeto.
- **data.csv**: Arquivo CSV de exemplo a ser carregado no bucket S3.

## Destruir a Infraestrutura

Para destruir a infraestrutura criada pelo Terraform, execute:

```bash
terraform destroy

  terraform destroy



