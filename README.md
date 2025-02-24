terraform import aws_instance.bia-dev i-0191a89d2816a9e66
terraform import aws_security_group.bia_dev sg-09d2fb24016a8aed1
 terraform state list visualizar os recurso que je temos
 terraform state show aws_security_group.bia_dev
 terraform output
 terraform state rm aws_security_group.bia_dev
 terraform init = Este comando descargará los proveedores necesarios y configurará el entorno de Terraform
 terraform init -migrate-state
 terraform plan = Verificar los Cambios antes de Aplicarlos
 https://developer.hashicorp.com/terraform/language/backend/s3 para configurar o s3 Bucket 
 para voltar ao state local da minha maquina
 terraform {
    backend "local" {

    }
 }
 + terraform init -migrate-state este comando inicializa el backend con el state local de novoi
 aula 9
 terraform import aws_security_group.bia_dev SEU_SG_ID
 terraform plan -generate-config-out=out_iam.tf
 terraform destroy -target='aws_instance.bia-dev'
 .........
 terraform plan -generate-config-out=out_iam.tf
 bloque de import.tf=
 import {
    id="role-acesso-ssm"
    to=aws_iam_role.role_acesso_ssm
}

import {
    id="role-acesso-ssm"
    to=aws_iam_instance_profile.role_acesso_ssm
}
...........

VINCULAR role a mi role_acesso_ssm, en el arquivo out_iam.tf

resource "aws_iam_instance_profile" "role_acesso_ssm" {
  name        = "role-acesso-ssm"
  name_prefix = null
  path        = "/"
  role        = aws_iam_role.role_acesso_ssm.name
  tags        = {}
  tags_all    = {}
}
..............
destruir un recurso alvo mi ec2 solamnete via comando terraform
............................................
Validar la Sintaxis de Terraform

Antes de aplicar los cambios, es importante asegurarte de que el código no tenga errores de sintaxis. 

terraform fmt

terraform validate
.....................................
SOLUÇÃO: Associar a IAM Role à Instância

Executa este comando para associar o perfil à tua instância bia-dev-tf:

 aws ec2 associate-iam-instance-profile --instance-id i-03b18fdf0c0a73d04 --iam-instance-profile Name=role-acesso-ssm
 ...........................................
 terraform destroy -target='aws_instance.bia-dev' elimina solo un servicio
 .........Aula 11 desafio 3
importar RDS desde out_deb.tf
 bia-tf$ terraform plan -generate-config-out=out_db.tf
 ......................................................
 Si necesitas cambiar el nombre de un recurso, es mejor usar terraform state mv en lugar de eliminarlo y recrearlo.

terraform state mv aws_security_group.bia.web aws_security_group.bia-web

terraform import aws_security_group.bia_web sg-02cecfede88199c2c importar SG directamente
