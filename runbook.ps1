# Install the AzureRm/Az module if not already installed
Install-Module -Name Az -Force -AllowClobber -Scope CurrentUser

# Import the Az module
Import-Module Az

# Connect to Azure using your service principal credentials
$servicePrincipalConnection = Get-AutomationConnection -Name "AzureRunAsConnection"
Connect-AzAccount -ServicePrincipal -Tenant $servicePrincipalConnection.TenantID -ApplicationId $servicePrincipalConnection.ApplicationID -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

# Set the AKS cluster information
$resourceGroupName = "YourResourceGroup"
$aksClusterName = "YourAKSCluster"
$aksNamespace = "YourKubernetesNamespace"
$cronJobName = "YourCronJob"

# Get AKS credentials
$aks = Get-AzAksCluster -ResourceGroupName $resourceGroupName -Name $aksClusterName
$aksContext = (kubectl config use-context $aksClusterName)

# Execute the Kubernetes CronJob
kubectl create job --from=cronjob/$cronJobName cleanup-job -n $aksNamespace

# Log the execution
$currentTime = Get-Date
Add-Content -Path "C:\Path\To\Your\LogFile.log" -Value "$currentTime: Cleanup job triggered in Kubernetes."

