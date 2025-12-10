# --- 1. Directory and Project Setup ---
# Anchor the working directory to the parent of the script (e.g., project root)
set cwd [file normalize [file join [file dirname [info script]] ".."]]
cd $cwd

# Define project name and directory
set proj_name "mul32-dadda-verilog"
set proj_dir  [file normalize [file join $cwd "${proj_name}-vivado"]]
set part_name "xc7a100tcsg324-1"
set board_part "digilentinc.com:nexys-a7-100t:part0:1.2"

# Check if project exists, open it if it does.
set proj_xpr  [file normalize [file join $proj_dir "${proj_name}.xpr"]]
if {[file exists $proj_xpr]} {
    puts "INFO: Opening existing project: $proj_xpr"
    open_project $proj_xpr
} else {
    puts "INFO: Creating new project in: $proj_dir"
    
    # Create the project
    create_project $proj_name $proj_dir -part $part_name
    
    # Set the board property now that it's manually installed
    set_property board_part $board_part_name [current_project]

    # --- 2. Add Design Sources (src/) ---
    set src_dir [file join $cwd "src"]
    if {[file isdirectory $src_dir]} {
        puts "INFO: Adding design sources from $src_dir"
        foreach f [glob -nocomplain -directory $src_dir *.v] {
            add_files -fileset sources_1 $f
        }
    } else {
        puts "WARNING: Source directory '$src_dir' not found."
    }

    # --- 3. Add Simulation Sources (tb/) ---
    set tb_dir [file join $cwd "tb"]
    if {[file isdirectory $tb_dir]} {
        puts "INFO: Adding simulation sources from $tb_dir"
        foreach f [glob -nocomplain -directory $tb_dir *.v] {
            add_files -fileset sim_1 $f
        }
    } else {
        puts "WARNING: Testbench directory '$tb_dir' not found."
    }

    # Save the project
    save_project
}

# Start the Vivado GUI
start_gui