#!/bin/bash

# Base directory setup
mdl_dir="mdl"
design_dir="netlistX6Y6/netlists_folder_0"
output_base_dir="measuresX6Y6"
final_measure_file="measuresX6Y6/measure0.measure"

# Ensure the final measure file exists and is empty
echo "" > "$final_measure_file"

# Initialize variables to store greatest fall and rise values
greatest_fall_value=""
greatest_fall_netlist=""
greatest_rise_value=""
greatest_rise_netlist=""

# Command to run and parse files from Y=0 to Y=9999
for Y in {0..4999}; do
    input_mdl="${mdl_dir}/X6teste.mdl"
    design_file="${design_dir}/netlist_config_${Y}.scs"
    output_measure="${output_base_dir}/teste${Y}.measure"
    measure_file="${output_measure}/X6teste.measure"

    # Run the spectremdl command
    spectremdl -batch "$input_mdl" -design "$design_file" -o "$output_measure"

    # Check if the output measure file exists
    if [ ! -f "$measure_file" ]; then
        echo "Measure file not found: $measure_file"
        continue
    fi

    # Extract values and update greatest fall and rise values
    while read -r line; do
        if [[ $line =~ diff_X6_to_Y[[:digit:]]+_(fall|rise)[[:space:]]*=[[:space:]]*([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?) ]]; then
            measurement="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            measure_key="diff_X6_to_Y${Y}_${measurement}"

            if [[ "$measurement" == "fall" ]]; then
                if [[ -z "$greatest_fall_value" || $(awk 'BEGIN {print ('$value' > '$greatest_fall_value')}') -eq 1 ]]; then
                    greatest_fall_value="$value"
                    greatest_fall_netlist="$design_file"
                fi
            elif [[ "$measurement" == "rise" ]]; then
                if [[ -z "$greatest_rise_value" || $(awk 'BEGIN {print ('$value' > '$greatest_rise_value')}') -eq 1 ]]; then
                    greatest_rise_value="$value"
                    greatest_rise_netlist="$design_file"
                fi
            fi
        fi
    done < "$measure_file"

    # Delete the directory
    rm -r "$output_measure"
done

# Write the greatest fall and rise values to the final measure file
echo "Greatest Fall Value     = $greatest_fall_value - $greatest_fall_netlist" >> "$final_measure_file"
echo "Greatest Rise Value     = $greatest_rise_value - $greatest_rise_netlist" >> "$final_measure_file"

echo "Process completed."
