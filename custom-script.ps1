Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mtm41/custom-script-extension-test/main/test.py' -OutFile .\test.py
$response = (C:\Users\devopsAdm37\AppData\Local\Programs\Python\Python310\python.exe .\test.py)
$key = $response | ConvertFrom-Json
$KeyVaultToken = $key.access_token

$pat = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-pat?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value
$acr = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-acr?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value
$agentPool = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-agent-pool?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value
$identity = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-identityID?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value
$org = (Invoke-RestMethod -Uri "https://vmss-devops-agents-kv.vault.azure.net/secrets/vmss-devops-agents-org?api-version=2016-10-01" -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}).value

az login --identity --username $identity
az acr login --name $acr

docker run -e AZP_URL="$org" -e AZP_TOKEN="$path" -e AZP_AGENT_NAME="$(hostname)" -e AZP_POOL="$agentPool" -d "$acr/azdevopsagent:1.1"
