package test

import (
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAzureEncryptionAndAccess(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../terraform/environments/azure",
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate CIS: Storage Account encryption
	storageAccountName := terraform.Output(t, terraformOptions, "storage_account_name")
	cred, _ := azidentity.NewDefaultAzureCredential(nil)
	client, _ := armstorage.NewAccountsClient("<subscription_id>", cred, nil)
	resp, _ := client.GetProperties(t.Context(), "<resource_group>", storageAccountName, nil)
	assert.True(t, *resp.Account.Properties.EnableHTTPSTrafficOnly, "Storage must enforce HTTPS (CIS encryption)")

	// Validate access control: No public blob access
	assert.False(t, *resp.Account.Properties.AllowBlobPublicAccess, "Storage must block public access (CIS)")

	// Validate VM encryption (query Azure API for host encryption status)
	vmName := terraform.Output(t, terraformOptions, "vm_name")
	// Add Azure Compute client query here for encryption_at_host_enabled
	// assert.True(t, encryptionEnabled, "VM must have host encryption")
}
