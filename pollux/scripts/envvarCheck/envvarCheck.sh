#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

OUTPUT_SCRIPT="$1"

> "$OUTPUT_SCRIPT"

# Ensure the output directory exists
mkdir -p "$(dirname "$OUTPUT_SCRIPT")"

# Function to check environment variables for abnormalities
check_env_variables() {
    # Create the report file
    {
        echo "## Checking Environment Variables"
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
}


# Main Execution
check_env_variables

