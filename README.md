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
................................................
Aula 11 todas las actualizaciones fuero echas hast el dia de hoy 24/02/25 rama donde trabaje aula 7

................................rds
  db_subnet_group_name                  = "default-vpc-0c5f464e37ffc5d93"

................ tareas en ejecucion del cluster reconfiguración de tu clúster o la creación de nuevos recursos, como nuevas Capacity Providers, Auto Scaling Groups o ECS
aws ecs list-tasks --cluster cluster-bia
aws ecs put-cluster-capacity-providers --cluster cluster-bia --capacity-providers [] --default-capacity-provider-strategy [] vinculacion con el cluster
 aws ecs delete-capacity-provider --capacity-provider cluster-bia eliminar el capasite provider vinculado al cluster
..........................Si estos Launch Templates están vinculados al Auto Scaling Group (ASG) que utilizaba el cluster-bia, entonces debes eliminarlos antes de ejecutar
velchael@Stalin-1OMD8BTE:/mnt/c/Users/55119/terraform/terraforme6/bia-tf$ aws ec2 describe-launch-templates --query "LaunchTemplates[*].LaunchTemplateName"
[
    "cluster-bia-web-20250305135118081000000001"
]
......... comando para ver la vinculacion de asg con launch_template
velchael@Stalin-1OMD8BTE:/mnt/c/Users/55119/terraform/terraforme6/bia-tf$ aws autoscaling describe-auto-scaling-groups --query "AutoScalingGroups[*].{Name:AutoScalingGroupName, LaunchTemplate:LaunchTemplate.LaunchTemplateName}"
[
    {
        "Name": "cluster-ecs-bia-asg-20250305135125823600000003",
        "LaunchTemplate": "cluster-bia-web-20250305135118081000000001"
    }
]
.................... comando terraform apply
terraform apply -auto-approve

Esto garantizará que Terraform cree un nuevo Cluster ECS, Auto Scaling Group, Capacity Provider y Launch Template sin conflictos. 
.......................  configuraciones conflictivas en tu aws_launch_template.tf
Estás usando vpc_security_group_ids fuera de network_interfaces, lo cual solo es válido si no defines explícitamente network_interfaces.

data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = "cluster-bia-web-"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = "t3.micro"
  vpc_security_group_ids = [ aws_security_group.bia_web.id ] 
  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = false }

  network_interfaces {
    associate_public_ip_address = true  # Habilita la IP pública
  }
  
  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.cluster-bia.name} >> /etc/ecs/ecs.config;
    EOF
  )
}
............. codigo actualizado

.............imprimir desde mi instacia cluster mis variables de anviente
docker exec aa7 printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=aa77f40a13aa
AWS_EXECUTION_ENV=AWS_ECS_EC2
DB_PORT=5432
DB_REGION=us-east-1
DB_SECRET_NAME=rds!db-dca317e4-4d20-4540-805a-5efdd20a47c5
AWS_CONTAINER_CREDENTIALS_RELATIVE_URI=/v2/credentials/be6a8219-331d-4b5a-94ee-383dfb4040aa
ECS_CONTAINER_METADATA_URI=http://169.254.170.2/v3/7ed1620c-e532-46e8-ade1-e742fc322a90
DB_HOST=bia.cf8k8gcse58z.us-east-1.rds.amazonaws.com
DEBUG_SECRET=true
ECS_CONTAINER_METADATA_URI_V4=http://169.254.170.2/v4/7ed1620c-e532-46e8-ade1-e742fc322a90
ECS_AGENT_URI=http://169.254.170.2/api/7ed1620c-e532-46e8-ade1-e742fc322a90
NODE_VERSION=22.14.0
YARN_VERSION=1.22.22
HOME=/root
