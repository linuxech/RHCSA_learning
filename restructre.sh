#!/bin/bash

# Define the professional RHCSA directory structure
folders=(
    "01_Essential_Tools"
    "02_Operation_of_Running_Systems"
    "03_Configuring_Local_Storage"
    "04_File_Systems_and_Attributes"
    "05_Deploy_and_Maintain_Systems"
    "06_Basic_Networking"
    "07_Manage_Users_and_Groups"
    "08_Security_and_SELinux"
    "09_Container_Management"
    "10_Mock_Exams_and_Labs"
)

# Create folders and placeholder READMEs
for folder in "${folders[@]}"; do
    mkdir -p "$folder"
    touch "$folder/README.md"
    echo "# $folder" > "$folder/README.md"
    echo "Add your notes and scripts for this section here." >> "$folder/README.md"
done

echo "Professional structure created successfully!"
