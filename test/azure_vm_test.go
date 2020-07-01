package test

import (
	"net"
	"strconv"
	"testing"

	//http_helper "github.com/gruntwork-io/terratest/modules/http-helper"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraform(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/azure-vm-with-ppro",
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the IP of the instance
	publicIp := terraform.Output(t, terraformOptions, "pip")
	port := 3389
	// Concatenate a colon and the port
	host := publicIp + ":" + strconv.Itoa(port)

	// Try to create a server with the port
	server, err := net.Dial("tcp", host)

	// if it fails then the port is likely taken
	if err != nil {
		panic(err)
	}

	assert.Nil(t, err)
	// close the server
	defer server.Close()

	// we successfully used and closed the port
	// so it's now available to be used again
	// Make an HTTP request to the instance and make sure we get back a 200 OK with the body "Hello, World!"
	//url := fmt.Sprintf("http://%s:8080", publicIp)
	//http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello, World!", 30, 5*time.Second)
}
