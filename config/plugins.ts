const path = require('path');
const fs = require('fs');

module.exports = ({ env }) => {
	let serviceAccount;

	if (env('NODE_ENV') === 'production') {
		serviceAccount = JSON.parse(env('GCP_SERVICE_ACCOUNT_JSON'));
	} else {
		const keyPath = path.join(
			process.cwd(),
			env('GCS_SERVICE_ACCOUNT_KEY_PATH', 'gcs-key.json'),
		);

		if (fs.existsSync(keyPath)) {
			const keyContent = fs
				.readFileSync(keyPath, 'utf8')
				.replace(/^\uFEFF/, ''); // Remove BOM if present
			serviceAccount = JSON.parse(keyContent);
			console.log('✅ GCS service account loaded successfully from:', keyPath);
		} else {
			console.error('❌ GCS service account key not found at:', keyPath);
			console.error('Current working directory:', process.cwd());
			console.error(
				'Please make sure gcs-key.json exists in your project root',
			);
			throw new Error(`GCS service account key not found at: ${keyPath}`);
		}
	}

	return {
		upload: {
			config: {
				provider:
					'@strapi-community/strapi-provider-upload-google-cloud-storage',
				providerOptions: {
					bucketName: env('GCS_BUCKET_NAME'),
					publicFiles: false,
					uniform: false,
					serviceAccount: serviceAccount,
					baseUrl: `https://storage.googleapis.com/${env('GCS_BUCKET_NAME')}`,
					basePath: '',
					signedUrlExpires: 60 * 60 * 24, // 24 hours
				},
			},
		},
		i18n: {
			enabled: true,
			config: {
				defaultLocale: 'en',
				locales: ['en', 'ka'],
			},
		},
		'users-permissions': {
			config: {
				register: {
					allowedFields: null,
				},
				email: {
					enabled: false,
				},
			},
		},
	};
};
