package test

import (
	"io/ioutil"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func minify(s string) string {
	return strings.Replace(strings.Replace(s, "\n", "", -1), " ", "", -1)
}

func TestSingleContainerDefinition(t *testing.T) {
	t.Parallel()
	options := &terraform.Options{
		TerraformDir: "..",
		VarFiles:     []string{"test/varfile.tfvars"},
	}
	defer terraform.Destroy(t, options)
	terraform.InitAndApply(t, options)
	b, err := ioutil.ReadFile("fixtures/single.json")
	if err != nil {
		t.Error(err)
	}
	expected := minify(string(b))
	actual := minify(terraform.Output(t, options, "container_definitions"))
	assert.Equal(t, expected, actual)
}

func TestMultipleContainerDefinitions(t *testing.T) {
	t.Parallel()
	options := &terraform.Options{
		TerraformDir: "../examples/terraform-task-definition-multiple-containers",
	}
	defer terraform.Destroy(t, options)
	terraform.InitAndApply(t, options)
	b, err := ioutil.ReadFile("fixtures/multiple.json")
	if err != nil {
		t.Error(err)
	}
	expected := minify(string(b))
	actual := minify(terraform.Output(t, options, "container_definitions"))
	assert.Equal(t, expected, actual)
}
