#!/bin/bash

# =========================================================
# User-Editable Variables
# =========================================================
USERNAME="nsaha"
DATE="Aug24"
INPUT_FILE="Prompt_MC.txt"
#INPUT_FILE="NonPrompt_MC.txt"
TEMPLATE_FILE="D0_MC_submit.py"

# Directory to save all generated crab configs
CONFIG_DIR="MC_configs_${DATE}"

# Safety checks
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Dataset list '$INPUT_FILE' not found!"
    exit 1
fi

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found in this directory!"
    exit 1
fi

# Create the config directory
mkdir -p "$CONFIG_DIR"

echo "Reading datasets from $INPUT_FILE..."
echo "Using Date Tag: $DATE"
echo "Configs will be saved to: $CONFIG_DIR/"

# Loop over each line (dataset) in the text file
while IFS= read -r DATASET; do
    # Skip empty lines and comments
    if [[ -z "$DATASET" || "$DATASET" == \#* ]]; then
        continue
    fi

    # 1. Extract the Primary Dataset name
    PD_NAME=$(echo "$DATASET" | cut -d '/' -f 2)
    
    # 2. Determine if it's Prompt or NonPrompt
    if [[ "$PD_NAME" == prompt* ]]; then
        PREFIX="Prompt"
    elif [[ "$PD_NAME" == nonprompt* ]]; then
        PREFIX="NonPrompt"
    else
        PREFIX="Unknown"
    fi

    # 3. Extract the pT bin number
    PT_NUM=$(echo "$PD_NAME" | grep -oP 'PT-\K\d+')

    # 4. Construct the dynamic 'data' variable
    DATA="${PREFIX}D0ToKPi_Dpt${PT_NUM}"
    
    # 5. Define the unique config file name
    CONFIG_FILE="${CONFIG_DIR}/crabConfig_${DATA}.py"

    echo "=========================================================="
    echo "Preparing submission for: $DATA"
    
    # Copy the template to the new config file
    cp "$TEMPLATE_FILE" "$CONFIG_FILE"

    # Use sed to replace the user-editable variables in the copied file.
    # We use ~ as the delimiter in sed so the slashes in the dataset path don't break it.
    sed -i "s~^username\s*=.*~username = '${USERNAME}'~" "$CONFIG_FILE"
    sed -i "s~^date\s*=.*~date = '${DATE}'~" "$CONFIG_FILE"
    sed -i "s~^data\s*=.*~data = '${DATA}'~" "$CONFIG_FILE"
    sed -i "s~^Dataset\s*=.*~Dataset = '${DATASET}'~" "$CONFIG_FILE"

    echo "Generated config: $CONFIG_FILE"

    # Submit the CRAB job using the newly saved config file
    crab submit -c "$CONFIG_FILE"
    
    echo "Finished submission block for $DATA."
    echo "=========================================================="
    
    # Brief pause to avoid overwhelming the CRAB server
    sleep 2

done < "$INPUT_FILE"

echo "All jobs processed! Your configuration files are saved in the '$CONFIG_DIR' folder."
