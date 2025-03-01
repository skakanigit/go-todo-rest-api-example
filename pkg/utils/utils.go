package utils

import (
	"fmt"
	"os"
)

func EnvGetOrDefault(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}

func EnvMustGet(key string) (string, error) {
	value := os.Getenv(key)
	if value == "" {
		return "", fmt.Errorf("environment variable %s is not set", key)
	}
	return value, nil
}
