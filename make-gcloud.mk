S := app

gcloud-cluster-init:
	gcloud container clusters get-credentials hexlet-basics-5 --region europe-west3-a

gcloud-builds:
	gcloud builds submit --config services/${S}/cloudbuild.yaml .

gcloud-compute-ssh:
	gcloud compute ssh ${I}

gcloud-docker-init:
	gcloud auth configure-docker

gcloud-sql-connect:
	gcloud beta sql connect master3 --user=hexlet_basics --database=hexlet_basics_prod
