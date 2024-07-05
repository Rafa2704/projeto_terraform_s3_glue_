
# Estão especificando o provider que é aws e a região, a região estará no arquivo variables
provider "aws" {
  region = var.region
}

# Como o bucket precisa ser único vamos passar um valor randômico de 2 palavras separados por hifen
resource "random_pet" "bucket_suffix" {
  length    = 2
  separator = "-"
}

# Aqui estamos criando o bucket, a variável bucket pega o valor que eu coloquei no arquivo de variáveis e concatena com os valores aleatórios que fez o arquivo de cima
resource "aws_s3_bucket" "data_bucket" {
  bucket = "${var.bucket_name_prefix}-${random_pet.bucket_suffix.id}"
  force_destroy = true
}

# A variável bucket armazena o nome que demos em cima, a key será onde ficará guardado o arquivo dentro do bucket em uma pasta chamada data
# A source é a pasta no meu computador, estamos passando no arquivo de variáveis
resource "aws_s3_object" "csv_file" {
  bucket = aws_s3_bucket.data_bucket.bucket
  key    = "data/african_crises.csv"
  source = var.source_file_path
}

# Este recurso cria uma função IAM (Identity and Access Management) para o serviço AWS Glue. A política assume_role_policy permite que o serviço Glue assuma esta função.
resource "aws_iam_role" "glue_service_role" {
  name = "glue_service_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Principal = {
          Service = "glue.amazonaws.com"
        },
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

# Este recurso anexa uma política gerenciada pela AWS (AWSGlueServiceRole) à função IAM criada anteriormente, concedendo as permissões necessárias para o serviço Glue.
resource "aws_iam_role_policy_attachment" "glue_service_policy" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Adiciona uma política inline à função IAM do Glue para permitir o acesso ao bucket S3
resource "aws_iam_role_policy" "glue_s3_access_policy" {
  name = "glue_s3_access_policy"
  role = aws_iam_role.glue_service_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.data_bucket.arn}",
          "${aws_s3_bucket.data_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Este recurso cria um banco de dados no catálogo do AWS Glue.
resource "aws_glue_catalog_database" "my_glue_database" {
  name = "my_glue_database"
}

# Este recurso cria um crawler no AWS Glue. O crawler é responsável por varrer o bucket S3 e catalogar os dados no banco de dados do Glue.
# Ele utiliza a função IAM criada anteriormente e aponta para o caminho S3 onde o arquivo CSV foi carregado
resource "aws_glue_crawler" "data_crawler" {
  name          = "data-crawler"
  role          = aws_iam_role.glue_service_role.arn
  database_name = aws_glue_catalog_database.my_glue_database.name
  s3_target {
    path = "s3://${aws_s3_bucket.data_bucket.bucket}/data/"
  }
}

# Adiciona uma política ao bucket S3 para permitir acesso à função do Glue
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.data_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.glue_service_role.arn
        },
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.data_bucket.arn}",
          "${aws_s3_bucket.data_bucket.arn}/*"
        ]
      }
    ]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}
