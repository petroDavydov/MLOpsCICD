<!-- eks-vpc-cluster/README.md -->

# Homework 5-6: Terraform AWS Infrastructure — VPC + EKS

Цей проєкт автоматизує створення повноцінної інфраструктури в AWS для майбутніх ML-сервісів. Він складається з двох основних модулів:

vpc/ — створення мережі VPC з підмережами, маршрутами та іншими необхідними ресурсами.

eks/ — розгортання Kubernetes-кластеру з CPU та GPU node group-ами


## Структура проєкту

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


## Передумови

 - Встановлений Terraform ≥ 1.5.0
 - AWS CLI з налаштованим профілем davydovpetro-homework-5-6
 - Доступ до AWS S3 та DynamoDB для зберігання стейту та блокування


## Крок 1: Ініціалізація Terraform

```bash
terraform init
```


 - Завантажує необхідні провайдери
 - Підключається до бекенду S3, де зберігається terraform.tfstate
 - Перевіряє конфігурацію модулів


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
aws eks --region eu-west-1 update-kubeconfig --name homework-5-6
```

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




















