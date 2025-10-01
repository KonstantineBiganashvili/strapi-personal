#!/bin/bash

# Check if .env exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    exit 1
fi

# Read values from .env
APP_KEYS=$(grep "^APP_KEYS=" .env | cut -d '=' -f2-)
API_TOKEN_SALT=$(grep "^API_TOKEN_SALT=" .env | cut -d '=' -f2-)
ADMIN_JWT_SECRET=$(grep "^ADMIN_JWT_SECRET=" .env | cut -d '=' -f2-)
TRANSFER_TOKEN_SALT=$(grep "^TRANSFER_TOKEN_SALT=" .env | cut -d '=' -f2-)
JWT_SECRET=$(grep "^JWT_SECRET=" .env | cut -d '=' -f2-)
DATABASE_PASSWORD=$(grep "^DATABASE_PASSWORD=" .env | cut -d '=' -f2-)

# Create secrets
echo "Creating secrets in Secret Manager..."

echo -n "$APP_KEYS" | gcloud secrets create app-keys --data-file=-
echo -n "$API_TOKEN_SALT" | gcloud secrets create api-token-salt --data-file=-
echo -n "$ADMIN_JWT_SECRET" | gcloud secrets create admin-jwt-secret --data-file=-
echo -n "$TRANSFER_TOKEN_SALT" | gcloud secrets create transfer-token-salt --data-file=-
echo -n "$JWT_SECRET" | gcloud secrets create jwt-secret --data-file=-
echo -n "$DATABASE_PASSWORD" | gcloud secrets create database-password --data-file=-

# Flatten gcs-key.json and create secret
echo "Flattening and creating gcs-service-account..."
if [ -f gcs-key.json ]; then
    cat gcs-key.json | tr -d '\n' | tr -s ' ' | gcloud secrets create gcs-service-account --data-file=-
else
    echo "Warning: gcs-key.json not found!"
fi

echo ""
echo "Done! Verify with: gcloud secrets list"