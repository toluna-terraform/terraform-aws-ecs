package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"

	awsSDK "github.com/aws/aws-sdk-go/aws"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the Terraform module in examples/terraform-aws-ecs-example using Terratest.
func TestTerraformAwsEcsExample(t *testing.T) {
	t.Parallel()

	// expectedClusterName := fmt.Sprintf("terratest-aws-ecs-example-cluster-%s", random.UniqueId())
	// expectedServiceName := fmt.Sprintf("terratest-aws-ecs-example-service-%s", random.UniqueId())

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	// awsRegion := aws.GetRandomStableRegion(t, []string{"us-east-1", "eu-west-1"}, nil)

	var awsRegion = "us-east-1"
	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/create-ecs",

		// Variables to pass to our Terraform code using -var options
		// Vars: map[string]interface{}{
		// 	"cluster_name": expectedClusterName,
		// 	"service_name": expectedServiceName,
		// 	"region":       awsRegion,
		// },
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	taskDefinition := terraform.Output(t, terraformOptions, "ecs_task_definition_arn")
	clusterName := terraform.Output(t, terraformOptions, "cluster_name")
	serviceName := terraform.Output(t, terraformOptions, "ecs_service_name")

	// Look up the ECS cluster by name
	cluster := aws.GetEcsCluster(t, awsRegion, clusterName)

	assert.Equal(t, int64(1), awsSDK.Int64Value(cluster.ActiveServicesCount))

	// Look up the ECS service by name
	service := aws.GetEcsService(t, awsRegion, clusterName, serviceName)

	assert.Equal(t, int64(1), awsSDK.Int64Value(service.DesiredCount))
	assert.Equal(t, "FARGATE", awsSDK.StringValue(service.LaunchType))

	// Look up the ECS task definition by ARN
	task := aws.GetEcsTaskDefinition(t, awsRegion, taskDefinition)

	assert.Equal(t, "512", awsSDK.StringValue(task.Cpu))
	assert.Equal(t, "2048", awsSDK.StringValue(task.Memory))
	assert.Equal(t, "awsvpc", awsSDK.StringValue(task.NetworkMode))
}
