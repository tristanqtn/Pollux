#!/bin/bash

# Paths
OUTPUT_DIR="/tmp/pollux/output"
OUTPUT_SCRIPT="$OUTPUT_DIR/envvarCheck.tmp"
PARSED_OUTPUT="$OUTPUT_DIR/parsed_envvarCheck.tmp"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Function to check environment variables for abnormalities
check_env_variables() {
    # Create the report file
    {
        echo "# Checking Environment Variables"
        echo "Generated on: $(date)"
        echo ""

        # Loop through environment variables
        for var in $(printenv | cut -d= -f1); do
            value=$(printenv "$var")

            # Simple checks for abnormalities
        if [[ "$var" == *"password"* || "$var" == *"secret"* || "$var" == *"key"* || "$var" == *"user"* || "$var" == *"pw"* || "$var" == *"id"* ]] || \
        [[ "$value" == *"password"* || "$value" == *"secret"* || "$value" == *"key"* || "$value" == *"user"* || "$value" == *"pw"* || "$value" == *"id"* ]]; then
                echo "Abnormal variable detected: $var"
                echo "Value: $value"
                echo ""
            fi
        done

        echo "Environment variable check completed."
        echo "***"
    } > "$OUTPUT_SCRIPT"

    echo "Environment variable report created: $OUTPUT_SCRIPT"
}


# Main Execution
check_env_variables

