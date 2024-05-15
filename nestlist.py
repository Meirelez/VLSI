import itertools
import os

def generate_netlist(switch_states, index, folder):
    if not os.path.exists(folder):
        os.makedirs(folder)  # Create the folder if it doesn't exist

    template_file = '8x8_tb_exc_netlist_2.scs'
    output_file = f"{folder}/netlist_config_{index}.scs"

    with open(template_file, 'r') as file:
        content = file.read()

    switches = [
        "S34", "S32", "S31", "S30",
        "S24", "S23", "S20",
        "S13", "S12", "S11", "S10",
        "S04", "S03", "S02", "S01"
    ]

    switch_configurations = '\n'.join(f"V_{s} ({s} 0) vsource dc={state} type=dc" for s, state in zip(switches, switch_states))
    modified_content = content.replace("// INSERT_SWITCHES_HERE", switch_configurations)

    with open(output_file, 'w') as file:
        file.write(modified_content)

def main():
    num_switches = 15  # Total number of switches you are controlling
    files_per_folder = 5000  # Limit to 1000 files per folder
    all_combinations = list(itertools.product([0, 1], repeat=num_switches))

    for idx, combo in enumerate(all_combinations):
        folder_index = idx // files_per_folder
        folder_name = f"netlists_folder_{folder_index}"
        generate_netlist(combo, idx % files_per_folder, folder_name)  # Pass the folder name to the function

    print(f"Generated {len(all_combinations)} configurations in multiple folders.")

if __name__ == "__main__":
    main()
