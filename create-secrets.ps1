# Read values from .env
$appKeys = (Select-String -Path .env -Pattern "^APP_KEYS=(.+)").Matches.Groups[1].Value
$apiTokenSalt = (Select-String -Path .env -Pattern "^API_TOKEN_SALT=(.+)").Matches.Groups[1].Value
$adminJwtSecret = (Select-String -Path .env -Pattern "^ADMIN_JWT_SECRET=(.+)").Matches.Groups[1].Value
$transferTokenSalt = (Select-String -Path .env -Pattern "^TRANSFER_TOKEN_SALT=(.+)").Matches.Groups[1].Value
$jwtSecret = (Select-String -Path .env -Pattern "^JWT_SECRET=(.+)").Matches.Groups[1].Value
$dbPassword = (Select-String -Path .env -Pattern "^DATABASE_PASSWORD=(.+)").Matches.Groups[1].Value

# Create secrets
echo $appKeys | gcloud secrets create app-keys --data-file=-
echo $apiTokenSalt | gcloud secrets create api-token-salt --data-file=-
echo $adminJwtSecret | gcloud secrets create admin-jwt-secret --data-file=-
echo $transferTokenSalt | gcloud secrets create transfer-token-salt --data-file=-
echo $jwtSecret | gcloud secrets create jwt-secret --data-file=-
echo $dbPassword | gcloud secrets create database-password --data-file=-

# Flatten gcs-key.json and create secret
$gcsKey = (Get-Content gcs-key.json -Raw) -replace '\r?\n','' -replace '\s+', ' '
echo $gcsKey | gcloud secrets create gcs-service-account --data-file=-

# Verify
gcloud secrets list