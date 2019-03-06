package terraform

import (
	"testing"
)

// Get calls terraform get and return stdout/stderr.
func Get(t *testing.T, options *Options) string {
	out, err := GetE(t, options)
	if err != nil {
		t.Fatal(err)
	}
	return out
}

// GetE calls terraform get and return stdout/stderr.
func GetE(t *testing.T, options *Options) (string, error) {
	return RunTerraformCommandE(t, options, "get", "-update")
}
