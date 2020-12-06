# realEstate_project

Live Demo: https://alexstaging.co/

## Development

Uses the default Django development server.

`docker-compose up -d --build`

Test it out at http://localhost:8000.

## Production

### Infrastructure

- Uses **Terraform** + **AWS**.
- Auto start/stop the instance to minimize the costs

```bash
export AWS_ACCESS_KEY_ID="accesskey"
export AWS_SECRET_ACCESS_KEY="secretkey"
export AWS_DEFAULT_REGION="ap-southeast-2"
terraform init
terraform plan
terraform apply
```

### Deployment

Uses **gunicorn** + **nginx** + **docker swarm**.

1. Update the environment variables & Rename .env.prod-sample to .env.prod and .env.prod.db-sample to .env.prod.db

2. Build the images

   > Note: You can't build an image specified in a Docker Compose file on Docker Swarm

   ```bash
   docker build -t web-prod  -f ./Dockerfile.prod .
   docker build -t nginx-prod  -f ./nginx/Dockerfile ./nginx
   ```

3. Deploy a new prod stack
   ```bash
   docker swarm init
   docker stack deploy --compose-file docker-compose.prod.yml prod-stack
   ```
