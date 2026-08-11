#!/bin/bash

# ==========================================
# USER SETTINGS
# ==========================================
CMS_USER="nsaha" #your user name
MIN_DATASET=0    #Min and Max PD will take care all failed lumi skimEDM
MAX_DATASET=0    # MIN_DATASET and MIN_DATASET range [0-31] corresponding to parent miniAOD!
MANUAL_DATE="Aug11"
INPUT_FILE="skim_edm_path.txt"
CONFIG_DIR="crab_configs"
# ==========================================

# Ensure the dataset file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File $INPUT_FILE not found!"
    exit 1
fi

# Create a directory to store all the generated config files
mkdir -p "$CONFIG_DIR"

echo "========================================================="
echo "User: $CMS_USER"
echo "Submitting HIPhysicsRawPrime datasets in range [$MIN_DATASET - $MAX_DATASET]"
echo "Saving generated config files to: ./$CONFIG_DIR/"
echo "========================================================="

# Declare an associative array to track the skim count for each base dataset
declare -A skim_counters

submitted_count=0

while IFS= read -r dataset; do
    # Skip empty lines
    if [[ -z "$dataset" ]]; then 
        continue 
    fi
    
    # Extract the dataset number using bash regex
    if [[ $dataset =~ ^/HIPhysicsRawPrime([0-9]+)/ ]]; then
        dataset_num="${BASH_REMATCH[1]}"
    else
        echo "Skipping line (does not match expected format): $dataset"
        continue
    fi

    # Check if the dataset number is within the assigned range
    if (( dataset_num >= MIN_DATASET && dataset_num <= MAX_DATASET )); then
        
        data_name="HIPhysicsRawPrime${dataset_num}"
        
        # Increment the counter for this specific dataset
        skim_counters["$data_name"]=$((skim_counters["$data_name"] + 1))
        skim_tag="skim${skim_counters["$data_name"]}"
        
        echo "---------------------------------------------------------"
        echo "--> Processing: $data_name ($skim_tag)"
        echo "--> EDM Path:   $dataset"
        
        # Path for the generated CRAB config file inside the directory
        temp_cfg="$CONFIG_DIR/crab_submit_${data_name}_${skim_tag}.py"
        
        # Copy the template to the new file
        cp D0_data_submit_skimEDM_template.py "$temp_cfg"
        
        # Replace the placeholders using sed
        sed -i "s|USER_NAME|$CMS_USER|g" "$temp_cfg"
        sed -i "s|DATA_NAME|$data_name|g" "$temp_cfg"
        sed -i "s|SKIM_TAG|$skim_tag|g" "$temp_cfg"
        sed -i "s|DATASET_PATH|$dataset|g" "$temp_cfg"
	    sed -i "s|CURRENT_DATE|$MANUAL_DATE|g" "$temp_cfg"
	
        # Submit the job from the generated config
        crab submit -c "$temp_cfg"
        
        submitted_count=$((submitted_count + 1))
        
        # Sleep to avoid overloading the CRAB server
        sleep 3
    fi
done < "$INPUT_FILE"

echo "========================================================="
echo "Done! Successfully submitted $submitted_count jobs."
echo "You can review all submitted configurations in the '$CONFIG_DIR' directory."
