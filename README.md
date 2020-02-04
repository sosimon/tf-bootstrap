# Terraform bootstrap

## Create Terraform service account

* `organization-application-component-environment`

```
SA_NAME=simon-cicd-terraform-dev
gcloud iam service-accounts create ${SA_NAME} --display-name "Terraform Service Account Dev"
SA_EMAIL=$(gcloud iam service-accounts list --filter=name~${SA_NAME} --format=json | jq -r '.[0].email')
gcloud iam service-accounts add-iam-policy-binding ${SA_EMAIL} --member="serviceAccount:${SA_EMAIL}" --role='roles/editor'
```

## Create state bucket(s)

* `organization-tf-state-cicd-environment`

```
BUCKET_NAME=simon-tf-state-cicd-dev
gsutil mb gs://${BUCKET_NAME}/
gsutil iam ch serviceAccount:${SA_EMAIL}:roles/storage.admin gs://${BUCKET_NAME}/
```

## Set GOOGLE_APPLICATION_CREDENTIALS

```
gcloud iam service-accounts keys create credentials.json --iam-account=${SA_EMAIL}
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/credentials.json"
```