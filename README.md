# Deploy Release Assets via FTP
This action deploys assets attached to a release to an FTP server. Please be
aware, that the assets have to be attached before publishing the release, assets
added later will not be uploaded.

## Purpose
We use this action to create plugin/theme releases for internal projects and clients
and push them to a private [WordPress Update Server](https://github.com/YahnisElsts/wp-update-server).

## Configuration

### Required Variables
* FTP Server: `${FTP_SERVER}` (without trailing '/', e.g. ftp.luehrsenheinrich.de)
* (Optional) Remote Dir: `${REMOTE_DIR}` (without leading /, e.g. trunk/upload/assets/ )

### Required Secrets
* FTP Username: `${FTP_USERNAME}`
* FTP Password: `${FTP_PASSWORD}`

Secrets can be set while editing your workflow or in the repository settings. They cannot be viewed once stored. [GitHub secrets documentation](https://developer.github.com/actions/creating-workflows/storing-secrets/)

## License
Our GitHub Actions are available for use and remix under the MIT license.
