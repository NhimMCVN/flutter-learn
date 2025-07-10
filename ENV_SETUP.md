# Environment Configuration Example

## How to use environment variables:

### 1. For Development:
```bash
flutter run --dart-define=AUTH_API_BASE_URL=https://dev-auth-api.example.com --dart-define=NOTES_API_BASE_URL=https://dev-notes-api.example.com --dart-define=ENVIRONMENT=development
```

### 2. For Staging:
```bash
flutter run --dart-define=AUTH_API_BASE_URL=https://staging-auth-api.example.com --dart-define=NOTES_API_BASE_URL=https://staging-notes-api.example.com --dart-define=ENVIRONMENT=staging
```

### 3. For Production:
```bash
flutter run --dart-define=AUTH_API_BASE_URL=https://prod-auth-api.example.com --dart-define=NOTES_API_BASE_URL=https://prod-notes-api.example.com --dart-define=ENVIRONMENT=production
```

### 4. Build with environment:
```bash
flutter build apk --dart-define=AUTH_API_BASE_URL=https://prod-auth-api.example.com --dart-define=NOTES_API_BASE_URL=https://prod-notes-api.example.com --dart-define=ENVIRONMENT=production
```

## Available Environment Variables:

- `AUTH_API_BASE_URL`: Base URL for authentication API endpoints
- `NOTES_API_BASE_URL`: Base URL for notes API endpoints  
- `ENVIRONMENT`: Current environment (development/staging/production)

## Default Values:

If no environment variables are provided, the app will use:
- AUTH_API_BASE_URL: https://x8ki-letl-twmt.n7.xano.io/api:qlhlF8OV
- NOTES_API_BASE_URL: https://x8ki-letl-twmt.n7.xano.io/api:D6nCcBx0
- ENVIRONMENT: development
