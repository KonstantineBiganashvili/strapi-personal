# Biganashvili CMS

A headless CMS built with Strapi v5, featuring Google Cloud Storage integration for media uploads, PostgreSQL database support, and internationalization (i18n) for English and Georgian languages.

## ✨ Features

- **Google Cloud Storage Integration** - Secure media upload and storage using GCS
- **Internationalization (i18n)** - Built-in support for English (en) and Georgian (ka) locales
- **PostgreSQL/MySQL/SQLite Support** - Flexible database options
- **Docker Ready** - Multi-stage Docker build for production deployment
- **TypeScript** - Full TypeScript support for type safety
- **RESTful API** - Auto-generated REST endpoints for all content types

## 📋 Prerequisites

- Node.js >= 18.0.0 <= 22.x.x
- npm >= 6.0.0
- PostgreSQL (or MySQL/SQLite for development)
- Google Cloud Platform account with Storage bucket (for production uploads)

## 🚀 Getting Started

### 1. Install Dependencies

```bash
npm install
```

### 2. Environment Configuration

Create a `.env` file in the root directory with the following variables:

```env
# Server
HOST=0.0.0.0
PORT=1337
NODE_ENV=development

# Secrets (generate using: openssl rand -base64 32)
APP_KEYS=your_app_keys_here
API_TOKEN_SALT=your_api_token_salt_here
ADMIN_JWT_SECRET=your_admin_jwt_secret_here
TRANSFER_TOKEN_SALT=your_transfer_token_salt_here
JWT_SECRET=your_jwt_secret_here
ENCRYPTION_KEY=your_encryption_key_here

# Database (choose one)
DATABASE_CLIENT=postgres  # or mysql, sqlite

# PostgreSQL
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=strapi
DATABASE_USERNAME=strapi
DATABASE_PASSWORD=your_secure_password
DATABASE_SSL=false

# Google Cloud Storage
GCS_BUCKET_NAME=your-bucket-name
GCS_SERVICE_ACCOUNT_KEY_PATH=gcs-key.json  # for local dev
# GCP_SERVICE_ACCOUNT_JSON={}  # for production (JSON string)
```

### 3. Google Cloud Storage Setup

1. Create a GCS bucket in your Google Cloud Console
2. Create a service account with Storage Admin permissions
3. Download the service account key JSON file
4. Save it as `gcs-key.json` in the project root (this file is gitignored)

**Note:** The `gcs-key.json` file should have the following structure:

```json
{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "...",
  "private_key": "...",
  "client_email": "...",
  ...
}
```

### 4. Run Development Server

```bash
npm run develop
```

The admin panel will be available at [http://localhost:1337/admin](http://localhost:1337/admin)

### 5. Build for Production

```bash
npm run build
npm run start
```

## 🐳 Docker Deployment

### Build Docker Image

```bash
npm run deploy:build
```

Or manually:

```bash
docker build -t biganashvili-cms .
```

### Test Locally with Docker

```bash
npm run deploy:test
```

Or manually:

```bash
docker run -p 1337:1337 --env-file .env biganashvili-cms
```

## 📦 Available Scripts

| Command                | Description                               |
| ---------------------- | ----------------------------------------- |
| `npm run develop`      | Start development server with auto-reload |
| `npm run start`        | Start production server                   |
| `npm run build`        | Build admin panel and compile TypeScript  |
| `npm run deploy:build` | Build Docker image                        |
| `npm run deploy:test`  | Test Docker container locally             |
| `npm run seed:example` | Seed database with example data           |
| `npm run strapi`       | Run Strapi CLI commands                   |

## 🔐 Google Cloud Secrets (Production)

For production deployment on Google Cloud Run or similar services, use the provided scripts to create secrets:

**PowerShell (Windows):**

```powershell
.\create-secrets.ps1
```

**Bash (Linux/Mac):**

```bash
chmod +x create-secrets.sh
./create-secrets.sh
```

These scripts will:

- Read values from your `.env` file
- Create Google Cloud Secret Manager secrets
- Store the flattened GCS service account key

## 🗄️ Database Configuration

The CMS supports multiple databases. Edit `config/database.ts` to change the default configuration.

**Development:** SQLite (default, no setup required)
**Production:** PostgreSQL or MySQL (recommended)

## 🌍 Internationalization

The CMS is configured with two locales:

- English (en) - Default
- Georgian (ka)

Content types can be localized through the admin panel.

## 📚 API Documentation

Once running, the API documentation is available at:

- REST API: `http://localhost:1337/api`
- Admin Panel: `http://localhost:1337/admin`

## ⚙️ Configuration Files

- `config/plugins.ts` - Plugin configuration (GCS, i18n, users-permissions)
- `config/database.ts` - Database connection settings
- `config/server.ts` - Server configuration
- `config/admin.ts` - Admin panel settings

## 🚨 Troubleshooting

### Build Errors

If you encounter build errors after modifying config files:

1. Delete the `dist` folder: `rm -rf dist` (or `Remove-Item -Recurse -Force dist` on Windows)
2. Rebuild: `npm run build`

### GCS Upload Issues

Ensure:

- The service account has the correct permissions (Storage Object Admin)
- The bucket name in `.env` matches your GCS bucket
- The `gcs-key.json` file is valid JSON without BOM characters

## 📚 Learn more

- [Resource center](https://strapi.io/resource-center) - Strapi resource center.
- [Strapi documentation](https://docs.strapi.io) - Official Strapi documentation.
- [Strapi tutorials](https://strapi.io/tutorials) - List of tutorials made by the core team and the community.
- [Strapi blog](https://strapi.io/blog) - Official Strapi blog containing articles made by the Strapi team and the community.
- [Changelog](https://strapi.io/changelog) - Find out about the Strapi product updates, new features and general improvements.

Feel free to check out the [Strapi GitHub repository](https://github.com/strapi/strapi). Your feedback and contributions are welcome!

## ✨ Community

- [Discord](https://discord.strapi.io) - Come chat with the Strapi community including the core team.
- [Forum](https://forum.strapi.io/) - Place to discuss, ask questions and find answers, show your Strapi project and get feedback or just talk with other Community members.
- [Awesome Strapi](https://github.com/strapi/awesome-strapi) - A curated list of awesome things related to Strapi.

---

<sub>🤫 Psst! [Strapi is hiring](https://strapi.io/careers).</sub>
