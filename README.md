# GCP Scheduled Functions Terraform

Simple module for creating with Terraform the following flow on GCP:

- dedicated service account used on the scheduled function

- custom role with project IAM binding on the dedicated service account

- gcs bucket hosting the function source code

- a series of cloud functions with the uploaded code and respective cloud scheduler job with access to cloud function


## Quickly testing the module

```
BUCKET=<YOUR_BUCKET_TO_CREATE>
PROJECT_ID=<YOUR_GCP_PROJECT>

cd examples/hello-world
terraform init
terraform plan -var "bucket=$BUCKET" -var "project_id=$PROJECT_ID" -out plan.out
terraform apply plan.out
cd ../../
```

If you change the source code just recreate the zip archive:

```
cd source-codes/code-1
zip code-1.zip main.py requirements.txt
cd ../../

cd source-codes/code-2
zip code-2.zip main.py requirements.txt
cd ../../
```

And relaunch Terraform to upload the new zip code and redeploy the function:

```
cd examples/hello-world
terraform plan -var "bucket=$BUCKET" -var "project_id=$PROJECT_ID" -out plan.out
terraform apply plan.out
cd ../../
```

Clean

```
cd examples/hello-world
terraform destroy -var "bucket=$BUCKET" -var "project_id=$PROJECT_ID"
cd ../../
```