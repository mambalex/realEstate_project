# realEstate_project

Live Demo: https://realestate.alexzhang.co

## Development

Uses the default Django development server.

`docker-compose up -d --build`

Test it out at http://localhost:8000

## Production

### Infrastructure

- Uses **Terraform** + **AWS**.
- Leverage spot instance to minimize the costs

> Note: Modify variables-sample and rename variables-sample to variables.tf

```bash
cd infra
export AWS_ACCESS_KEY_ID="accesskey"
export AWS_SECRET_ACCESS_KEY="secretkey"
export AWS_DEFAULT_REGION="ap-southeast-2"
terraform init
terraform plan
terraform apply
```

### Deployment

Tools:

- **Gunicorn**
- **Nginx**
- **Let’s Encrypt**
- **Docker Swarm**

1. Clone the repo

   ```bash
   ssh ec2@xxx.xx.xx -i key_name.pem
   git clone https://github.com/mambalex/realEstate_project.git
   cd realEstate_project
   ```

2. Update the environment variables & Rename .env.prod-sample to .env.prod and .env.prod.db-sample to .env.prod.db

   > Note: update the DJANGO_ALLOWED_HOSTS in .env.prod or it won't work

3. Seeding database `realestatedb_init.sql`

4. Build the images

   > Note: You can't build an image specified in a Docker Compose file on Docker Swarm

   ```bash
   docker build -t web-prod  -f ./Dockerfile.prod .
   docker build -t nginx-prod  -f ./nginx/Dockerfile ./nginx
   ```

5. Set up SSL

   - Automatic Certificate Renewal

   > Note: Don't forget to add domains and email addresses to init-letsencrypt.sh

   ```bash
   ./init-letsencrypt.sh
   ```

6. Deploy a new prod stack
   ```bash
   docker swarm init
   docker stack deploy --compose-file docker-compose.prod.yml prod-stack
   ```
