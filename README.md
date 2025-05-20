# n8n Docker Compose Setup

[日本語版 (Japanese Version)](README_ja.md)

This project provides configuration files to easily start and manage [n8n](https://n8n.io/) using Docker Compose.
It also includes a Makefile to simplify exporting and importing workflows and credentials.

## Prerequisites

*   Docker
*   Docker Compose

## Setup

1.  **Prepare Configuration File:**
    Create a file named `config` in the root of the repository with the following content:
    ```json
    {
        "encryptionKey": "YOUR_VERY_SECRET_ENCRYPTION_KEY"
    }
    ```
    Replace `YOUR_VERY_SECRET_ENCRYPTION_KEY` with your actual secret key for encrypting n8n credentials.
    This key will be set as the `N8N_ENCRYPTION_KEY` environment variable in `docker-compose.yaml`.

2.  **Create Data Directories:**
    Create directories to store exported workflows and credentials.
    ```bash
    mkdir -p workflows credentials
    ```
    These directories are mounted to `/home/node/workflows` and `/home/node/credentials` in the container via `docker-compose.yaml`.

## How to Run

Use the commands defined in the Makefile to operate n8n.

*   **Start n8n:**
    ```bash
    make up
    ```
    n8n will be accessible at `http://localhost:5678`.

*   **Stop n8n:**
    ```bash
    make down
    ```

*   **View Logs:**
    ```bash
    make logs
    ```

## Exporting/Importing Workflows and Credentials

*   **Export Workflows:**
    Exports all workflows to the `./workflows/` directory. (Individual files will be generated if multiple workflows exist).
    ```bash
    make export-workflows
    ```

*   **Import Workflows:**
    Imports workflows from `./workflows/workflows.json`. If you exported multiple workflow files, you may need to rename the desired file to `workflows.json` or merge them.
    ```bash
    make import-workflows
    ```

*   **Export Credentials:**
    Exports all credentials to the `./credentials/` directory. (Individual files will be generated if multiple credentials exist).
    ```bash
    make export-credentials
    ```

*   **Import Credentials:**
    Imports credentials from `./credentials/credentials.json`. If you exported multiple credential files, you may need to rename the desired file to `credentials.json` or merge them.
    ```bash
    make import-credentials
    ```

**Caution:** Import commands may overwrite existing data. Use with care.

## Configuration

### `N8N_ENCRYPTION_KEY`

The `N8N_ENCRYPTION_KEY` environment variable is set in the `docker-compose.yaml` file.
For security, it is recommended to use an `.env` file for this key and add `.env` to your `.gitignore` instead of writing the key directly into `docker-compose.yaml`.

Example `.env` file:
```
N8N_ENCRYPTION_KEY=YOUR_VERY_SECRET_ENCRYPTION_KEY
```

Changes in `docker-compose.yaml`:
```yaml
services:
  n8n:
    # ...
    environment:
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY} # Modified to read from .env file
    # ...
```

### Timezone

If necessary, enable the commented-out timezone settings in the `docker-compose.yaml` file.

```yaml
    environment:
      - N8N_ENCRYPTION_KEY=o9C/a9AQ8mZ/hoSTkjbSiW5Bx3B4Gm/1
      # Set GENERIC_TIMEZONE and TZ to specify the timezone
      - GENERIC_TIMEZONE=Asia/Tokyo # Example: Japan Standard Time
      - TZ=Asia/Tokyo             # Example: Japan Standard Time
```

## Directory Structure

```
.
├── Makefile              # Makefile for n8n operations
├── config                # n8n configuration file (e.g., encryption key)
├── credentials/          # Exported credentials (credentials.json)
├── docker-compose.yaml   # Docker Compose configuration file
├── workflows/            # Exported workflows (workflows.json)
├── README.md             # This file (English)
└── README_ja.md          # Japanese version of README
``` 
