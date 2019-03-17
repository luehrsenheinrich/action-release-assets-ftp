#!/bin/bash

# "to avoid continuing when errors or undefined variables are present"
set -eu

ls -R .

# Include some helper functions
. "./includes.sh"

# Ensure FTP server, username and password are set
# IMPORTANT: secrets are accessible by anyone with write access to the repository!
if [[ -z "$FTP_USERNAME" ]]; then
	echo "Set the FTP_USERNAME secret"
	exit 1
fi

if [[ -z "$FTP_PASSWORD" ]]; then
	echo "Set the FTP_PASSWORD secret"
	exit 1
fi

if [[ -z "$FTP_SERVER" ]]; then
	echo "Set the FTP_SERVER secret"
	exit 1
fi

if [[ $GITHUB_EVENT_NAME != "release" ]]; then
	echo "This is not a release, aborting!"
	exit 78
fi

echo "Downloading and parsing the event file"
assets=( $(jq -r '.release.assets[] | @base64' "$GITHUB_EVENT_PATH") )
tag_name=$(jq -r .release.tag_name "$GITHUB_EVENT_PATH")

echo "Handling release tag $tag_name"

echo "Creating the temporary directory for the assets"
mkdir tmp_assets

WDEFAULT_LOCAL_DIR=${LOCAL_DIR:-""}
WDEFAULT_REMOTE_DIR=${REMOTE_DIR:-""}

for asset64 in "${assets[@]}"
do
 	asset=$(base64 --decode <<< "${asset64}")
  	asset_id=$(jq -r '.id' <<< "${asset}")
	name=$(jq -r '.name' <<< "${asset}")
  	echo "Downloading ${name} to the temporary directory"
	
	FTP_USERNAME_ENC=$( urlencode ${FTP_USERNAME} )
	FTP_PASSWORD_ENC=$( urlencode ${FTP_PASSWORD} )

	AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
	ASSET_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/assets/${asset_id}"
	FILE="tmp_assets/${name}"
	FTP_UPLOAD_URL="ftp://${FTP_USERNAME_ENC}:${FTP_PASSWORD_ENC}@${FTP_SERVER}/${WDEFAULT_REMOTE_DIR}"
	
	curl \
          -s \
	  -L \
	  -H "${AUTH_HEADER}" \
	  -H "Accept:application/octet-stream" \
	  -o "${FILE}" \
	  "${ASSET_URL}"
	
	echo "Uploading ${name} to ${FTP_SERVER}"
	
	curl \
          -s \
	  -T "${FILE}" \
	  "${FTP_UPLOAD_URL}"
done

echo "Deploy of release assets to ${FTP_SERVER} successful"
