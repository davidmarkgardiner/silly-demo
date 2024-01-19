# // tahe json file as input and update script.sh
# // with the new values

# // read json file

# // script should update domain.yaml with new vaules

# /// if sbdomain and domain are empty then use subdomain = ${namepsace}-${env} and domain = ${default.domain.com}

#!/bin/bash

# Path to the JSON file
JSON_FILE="data.json"

# Read values from the JSON file
subdomain=$(jq -r '.subdomain' $JSON_FILE)
domain=$(jq -r '.domain' $JSON_FILE)
namespace=$(jq -r '.namespace' $JSON_FILE)
env=$(jq -r '.env' $JSON_FILE)
region=$(jq -r '.region' $JSON_FILE)

# if region is westeuprot the $clustername == cluster-westeurope if region eastus2 then %clustername == cluster-eastus2
if [ "$region" == "westeurope" ]; then
  clustername="cluster-westeurope"
fi
if [ "$region" == "eastus2" ]; then
  clustername="cluster-eastus2"
fi

# If subdomain and domain are empty, use default values
if [ -z "$subdomain" ] || [ "$subdomain" == "null" ]; then
  subdomain="${namespace}-${env}"
fi

if [ -z "$domain" ] || [ "$domain" == "null" ]; then
  domain="default.domain.com"
fi

# Create domain.yaml if it doesn't exist
if [ ! -f domain.yaml ]; then
  echo '{}' > domain.yaml
fi

# # Update domain.yaml with new values using jq
cat << EOF > domain.yaml
subdomain: $subdomain
domain: $domain
namespace: $namespace
env: $env
region: $region
EOF

# Update domain.yaml with new values using yq
# yq eval ".subdomain = \"$subdomain\"" -i domain.yaml
# yq eval ".domain = \"$domain\"" -i domain.yaml
# yq eval ".namespace = \"$namespace\"" -i domain.yaml
# yq eval ".env = \"$env\"" -i domain.yaml
# yq eval ".region = \"$region\"" -i domain.yaml