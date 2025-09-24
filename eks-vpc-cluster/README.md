<!-- eks-vpc-cluster/README.md -->
# Homework 7: MlFlow, ArgoCD, EKS, VPC, Terraform

!!! "Цей проєкт використовує Terraform та пов'язаний з репозиторієм [MLOpsCICD-GitOps-Argo](https://github.com/petroDavydov/MLOpsCICD-GitOps-Argo)" 

Цей проєкт автоматизує створення повноцінної інфраструктури в AWS для майбутніх ML-сервісів. Він складається з трех основних модулів:

vpc/ — створення мережі VPC з підмережами, маршрутами та іншими необхідними ресурсами.

eks/ — розгортання Kubernetes-кластеру з CPU та GPU node group-ами

а також додаткового модуля argocd для розгортання ArgoCD.

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
├── argocd/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── provider.tf
│ ├── terraform.tf
│ ├── backend.tf
│ └── values/
│ └── argocd-values.yaml
|--README.md
```

## Передумови

 - Встановлений Terraform ≥ 1.5.0
 - AWS CLI з налаштованим профілем davydovpetro-homework-7
 - Доступ до AWS S3 та DynamoDB для зберігання стейту та блокування


##### за відсутності профілю вказаного у роботі, створіть його за звичайним сценарієм:
```
aws configure --profile davydovpetro-homework-7
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
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1 \
  --profile davydovpetro-homework-7
```

```
aws dynamodb create-table \
  --table-name davydovpetro-homework-7-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region eu-west-1 \
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
aws eks --region eu-west-1 update-kubeconfig --name homework-7 --profile davydovpetro-homework-7
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

-----------------------------------------------
-----------------------------------------------
# Кроки для запуску ArgoCD (eks-vps-cluster/argocd/)

Перейти в папку argocd

```bash
cd argocd
``` 

## Ініціалізувати Terraform

```bash
terraform init
```

Це:
 - Підключить провайдери (aws, kubernetes, helm)
 - Зчитає кластер з remote state
 - Підготує Helm-реліз ArgoCD


## Запустити деплой ArgoCD

```bash
terraform apply
```

Це:
 - Створить namespace infra-tools
 - Встановить ArgoCD через Helm
 - Підтягне argocd-values.yaml


## Перевірити, що ArgoCD працює

```bash
kubectl get pods -n infra-tools
``` 

Очікування побачити:
  argocd-server-xxxxx
  argocd-repo-server-xxxxx
  argocd-application-controller-xxxxx
  argocd-dex-server-xxxxx


## Відкрити доступ до ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n infra-tools 8080:443
``` 

Після цього відкривайте у браузері

```
http://localhost:8080

```


## Логін у ArgoCD

```bash
kubectl get secret argocd-initial-admin-secret -n infra-tools -o jsonpath="{.data.password}" | base64 -d; echo
``` 
логін: admin
пароль: <пароль виведе команда вище>


#### *Після цього ArgoCD  готовий до підключення Git-репозиторію `MLOpsCICD-GitOps-Argo` і автоматичного деплою MLflow або nginx.


Перед запуском terraform apply переконайтесь, що argocd_namespace створюється автоматично або вже існує. Terraform створює його через kubernetes_namespace.

Helm provider використовує зовнішній kubernetes provider, підключений до EKS через remote state. Вкладений блок kubernetes {} у provider "helm" не використовується.


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


#### Опціональні перевірки

* Ресурси ноди
```bash
kubectl describe node ip-10-0-1-239.eu-west-1.compute.internal
```

* Кластерні аддони
```bash
kubectl get pods -n kube-system
```
