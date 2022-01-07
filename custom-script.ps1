Start-Sleep -Seconds 60
$response = Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -Method GET -Headers @{Metadata="true"}
echo "$response" >> log.txt 
$key = $response.Content | ConvertFrom-Json
echo "$key" >> log.txt
$KeyVaultToken = $key.access_token

$pat = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-pat?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value
$acr = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-acr?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value
$agentPool = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-agent-pool?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value
$identity = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-identityID?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value
$org = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-org?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value
echo "$pat" >> log.txt
az login --identity --username $identity

docker run -e AZP_URL="$org" -e AZP_TOKEN="$path" -e AZP_AGENT_NAME="$(hostname)" -e AZP_POOL="$agentPool" -d "$acr/azdevopsagent:latest"
