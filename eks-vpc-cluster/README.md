<!-- eks-vpc-cluster/README.md -->
# Homework 5-6: Terraform AWS Infrastructure — VPC + EKS

Цей проєкт автоматизує створення повноцінної інфраструктури в AWS для майбутніх ML-сервісів. Він складається з двох основних модулів:

vpc/ — створення мережі VPC з підмережами, маршрутами та іншими необхідними ресурсами.

eks/ — розгортання Kubernetes-кластеру з CPU та GPU node group-ами


## Структура проєкту
```
eks-vps-cluster/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tf
├── backend.tf
├── vpc/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tf
│   └── backend.tf
├── eks/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tf
│   ├── backend.tf
│   └── data.tf
|--README.md
```

## Передумови

 - Встановлений Terraform ≥ 1.5.0
 - AWS CLI з налаштованим профілем davydovpetro-homework-5-6
 - Доступ до AWS S3 та DynamoDB для зберігання стейту та блокування


##### за відсутності профілю вказаного у роботі, створіть його за звичайним сценарієм:
```
aws configure --profile davydovpetro-homework-5-6
...
...
...
...
```
##### Ця команда перевірить які профілі у вас існують:
aws configure list-profiles

## 0. Ініціалізація бекенду

Перед запуском `terraform init`, створіть S3-бакет і DynamoDB-таблицю:

```
aws s3api create-bucket \
  --bucket davydovpetro-homework-7-tfstate \
  --region us-east-1 \
  --create-bucket-configuration LocationConstraint=us-east-1 \
  --profile davydovpetro-homework-7
```

```
aws dynamodb create-table \
  --table-name davydovpetro-homework-7-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1 \
  --profile davydovpetro-homework-7
```

Це потрібно для зберігання Terraform state і блокування.

* У модулях `vpc/` та `eks/` також прописані `backend.tf`, але вони закоментовані, щоб уникнути дублювання бекенду. Основний бекенд знаходиться в корені проєкту (`eks-vpc-cluster/backend.tf`) і використовується для зберігання глобального стейту.


## Крок 1: Ініціалізація Terraform

```bash
terraform init
```
Ця команда:
 - Завантажує необхідні провайдери
 - Підключається до бекенду S3, де зберігається terraform.tfstate
 - Перевіряє конфігурацію модулів


P.S. Якщо після команди terraform init, Ви побачите помилку:
```Version could not be resolved (set by /home/yorname/.tfenv/version or tfenv use <version>)```

виконайте команду:
```echo "1.5.0" > .terraform-version && cp .terraform-version vpc/ && cp .terraform-version eks/```
це створить файл .terraform-version у корені проекту, та скопіює його в vpc та eks, ви також можете додати його у .gitignore, щоб не пушити його в репозиторій.


## Крок 2: Створення інфраструктури

```bash
terraform apply
```

 - Створює VPC з публічними та приватними сабнетами
 - cpu-nodes — інстанси t3.medium
 - gpu-nodes — інстанси g4dn.xlarge з taints і labels
 - Налаштовує кластерні аддони: coredns, kube-proxy, vpc-cni, eks-pod-identity-agent
 - Після підтвердження (yes) інфраструктура буде створена.


## Крок 3: Підключення до кластеру

```bash
aws eks --region us-east-1 update-kubeconfig --name homework-7 --profile davydovpetro-homework-7
```
Ця команда:
 - Оновлює локальний kubeconfig файл
 - Додає доступ до кластеру через kubectl


## Крок 4: Перевірка доступу до кластеру

```bash
kubectl get nodes
```

Очікуваний результат:
 - Побачити дві групи нод: CPU та GPU
 - Статус Ready для кожної ноди


# Повне видалення інфраструктури

```bash
terraform destroy
```

Ця команда:
 - Видаляє всі ресурси, створені Terraform
 - Якщо S3-бакет входить до конфігурації — він також буде видалений


#### Примітки
    - Всі змінні централізовані в variables.tf у корені
    - Профіль AWS задається через provider_profile
    - Зв’язок між модулями здійснюється через terraform_remote_state
    - Кожен модуль має власний бекенд для ізольованого стейту


* Ви також можете використовувати ```terraform plan```, щоб попередньо переглянути, які ресурси будуть створені або змінені, без фактичного застосування змін.

```* УВАГА: Щоб бути повністю впевненим у видаленні всіх ресурсів, перевірте, ще раз ваше видалення у своєму кабінеті на aws !!!```


# Додаткові дані:
GPU node group конфігурована відповідно до вимог, але її створення заблоковано через обмеження AWS. Це типова ситуація для нових акаунтів. Конфігурація зберігається, і після підвищення ліміту вона буде активована без змін.
##### Помилка при створенні GPU node group:
```
Error: waiting for EKS Node Group (homework-5-6:gpu-nodes-20250919104218632400000018) create: unexpected state 'CREATE_FAILED', wanted target 'ACTIVE'. last error: eks-gpu-nodes-20250919104218632400000018-deccb0c8-ab63-48ae-c3ec-655b89bf0883: AsgInstanceLaunchFailures: Could not launch On-Demand Instances. VcpuLimitExceeded - You have requested more vCPU capacity than your current vCPU limit of 0 allows for the instance bucket that the specified instance type belongs to. Please visit http://aws.amazon.com/contact-us/ec2-request to request an adjustment to this limit. Launching EC2 instance failed.
│ 
│   with module.eks.module.eks.module.eks_managed_node_group["gpu-nodes"].aws_eks_node_group.this[0],
│   on .terraform/modules/eks.eks/modules/eks-managed-node-group/main.tf line 395, in resource "aws_eks_node_group" "this":
│  395: resource "aws_eks_node_group" "this" 
```

```
Помилка: очікування групи вузлів EKS (домашнє завдання-5-6:gpu-nodes-20250919104218632400000018) створення: неочікуваний стан 'CREATE_FAILED', бажана ціль 'ACTIVE'. остання помилка: eks-gpu-nodes-20250919104218632400000018-deccb0c8-ab63-48ae-c3ec-655b89bf0883: AsgInstanceLaunchFailures: Не вдалося запустити екземпляри на вимогу. VcpuLimitExceeded - Ви запросили більшу потужність віртуального процесора (vCPU), ніж дозволяє ваш поточний ліміт vCPU, що дорівнює 0, для корзини екземплярів, до якої належить зазначений тип екземпляра. Будь ласка, відвідайте http://aws.amazon.com/contact-us/ec2-request, щоб подати запит на коригування цього ліміту. Запуск екземпляра EC2 не вдався. │ 
│ з module.eks.module.eks.module.eks_managed_node_group["gpu-nodes"].aws_eks_node_group.this[0],
│ на .terraform/modules/eks.eks/modules/eks-managed-node-group/main.tf рядок 395, у ресурсі "aws_eks_node_group" "this":
│ 395: ресурс "aws_eks_node_group" "this" 
```

#### Опціональні перевірки

* Ресурси ноди
```bash
kubectl describe node ip-10-0-1-239.us-east-1.compute.internal
```

* Кластерні аддони
```bash
kubectl get pods -n kube-system
```
