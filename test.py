import requests

headers = {'Metadata': 'true'}
resp = requests.get('http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net', headers=headers)
print(resp.text)
