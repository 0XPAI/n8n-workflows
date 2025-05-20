# n8n Docker Compose セットアップ

このプロジェクトは、[n8n](https://n8n.io/) を Docker Compose を使用して簡単に起動・管理するための設定ファイルを提供します。
また、Makefile を使用して、ワークフローや認証情報のエクスポート・インポートを簡単に行うことができます。

## 前提条件

*   Docker
*   Docker Compose

## セットアップ

1.  **設定ファイルの準備:**
    リポジトリのルートに `config` という名前のファイルを作成し、以下の内容を記述します。
    ```json
    {
        "encryptionKey": "YOUR_VERY_SECRET_ENCRYPTION_KEY"
    }
    ```
    `YOUR_VERY_SECRET_ENCRYPTION_KEY` はn8nの認証情報などを暗号化するためのキーです。実際のキーに置き換えてください。
    このキーは `docker-compose.yaml` の `N8N_ENCRYPTION_KEY` 環境変数に設定されます。

2.  **データ用ディレクトリの作成:**
    エクスポートされたワークフローと認証情報を保存するためのディレクトリを作成します。
    ```bash
    mkdir -p workflows credentials
    ```
    これらのディレクトリは、`docker-compose.yaml` によってコンテナ内の `/home/node/workflows` および `/home/node/credentials` にマウントされます。

## 実行方法

Makefile に定義されたコマンドを使用して n8n を操作します。

*   **n8n の起動:**
    ```bash
    make up
    ```
    n8n は `http://localhost:5678` でアクセス可能になります。

*   **n8n の停止:**
    ```bash
    make down
    ```

*   **ログの確認:**
    ```bash
    make logs
    ```

## ワークフローと認証情報のエクスポート/インポート

*   **ワークフローのエクスポート:**
    全てのワークフローを `./workflows/` ディレクトリにエクスポートします。(複数のワークフローが存在する場合、個別のファイルが生成されます)。
    ```bash
    make export-workflows
    ```

*   **ワークフローのインポート:**
    `./workflows/workflows.json` からワークフローをインポートします。複数のワークフローファイルをエクスポートした場合は、対象のファイルを `workflows.json` にリネームするか、内容を1つのファイルに統合する必要がある場合があります。
    ```bash
    make import-workflows
    ```

*   **認証情報のエクスポート:**
    全ての認証情報を `./credentials/` ディレクトリにエクスポートします。(複数の認証情報が存在する場合、個別のファイルが生成されます)。
    ```bash
    make export-credentials
    ```

*   **認証情報のインポート:**
    `./credentials/credentials.json` から認証情報をインポートします。複数の認証情報ファイルをエクスポートした場合は、対象のファイルを `credentials.json` にリネームするか、内容を1つのファイルに統合する必要がある場合があります。
    ```bash
    make import-credentials
    ```

**注意:** インポートコマンドは既存のデータを上書きする可能性があるため、慎重に実行してください。

## 設定

### `N8N_ENCRYPTION_KEY`

`docker-compose.yaml` ファイル内で `N8N_ENCRYPTION_KEY` 環境変数を設定しています。
セキュリティのため、このキーを直接 `docker-compose.yaml` に記述する代わりに、`.env` ファイルを使用し、そのファイルを `.gitignore` に追加することを推奨します。

例: `.env` ファイル
```
N8N_ENCRYPTION_KEY=YOUR_VERY_SECRET_ENCRYPTION_KEY
```

`docker-compose.yaml` の変更箇所:
```yaml
services:
  n8n:
    # ...
    environment:
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY} # .envファイルから読み込むように変更
    # ...
```

### タイムゾーン

必要に応じて、`docker-compose.yaml` ファイル内のコメントアウトされたタイムゾーン設定を有効にしてください。

```yaml
    environment:
      - N8N_ENCRYPTION_KEY=o9C/a9AQ8mZ/hoSTkjbSiW5Bx3B4Gm/1
      # GENERIC_TIMEZONE と TZ を設定することでタイムゾーンを指定できます
      - GENERIC_TIMEZONE=Asia/Tokyo # 例: 日本時間
      - TZ=Asia/Tokyo             # 例: 日本時間
```

## ディレクトリ構成

```
.
├── Makefile              # n8n操作用Makefile
├── config                # n8n設定ファイル (暗号化キーなど)
├── credentials/          # エクスポートされた認証情報 (credentials.json)
├── docker-compose.yaml   # Docker Compose設定ファイル
├── workflows/            # エクスポートされたワークフロー (workflows.json)
├── README.md             # README (英語版)
└── README_ja.md          # このファイル (日本語版)
``` 
