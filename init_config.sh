#!/bin/sh

# Use the directory where this init script was actually found
DIR="$(dirname "$INIT_SCRIPT")"
DEFAULT_FILE="$DIR/test_pubs_default_settings.json"
USER_FILE="$DIR/test_pubs_user_settings.json"

# 2. The Pure POSIX JSON Extractor
extract_json_value() {
    key="$1"
    file="$2"
    
    if [ -f "$file" ]; then
        awk -F':' -v k="\"$key\"" '
        $1 ~ k {
            # Grab everything after the first colon
            val = substr($0, index($0, $2))
            
            # Strip leading spaces/tabs
            sub(/^[ \t]+/, "", val)
            
            # Strip trailing commas and spaces
            sub(/,[ \t]*$/, "", val)
            
            # Strip the surrounding quotes (for strings)
            sub(/^"/, "", val)
            sub(/"$/, "", val)
            
            print val
            exit
        }' "$file"
    fi
}

# 3. The Fallback Logic (User > Default)
get_setting() {
    key="$1"
    
    # Check the user settings first
    val=$(extract_json_value "$key" "$USER_FILE")
    
    # If the user value is empty (doesn't exist), grab the default setting
    if [ -z "$val" ]; then
        val=$(extract_json_value "$key" "$DEFAULT_FILE")
    fi
    
    echo "$val"
}

# --- 4. Load the values into global variables ---
CONFIG_HW_FALLBACK=$(get_setting "hw_fallback")
CONFIG_COMPILATOR=$(get_setting "compilator")
CONFIG_SOURCE_FILE=$(get_setting "source_file")
CONFIG_COMPILED_BINARY=$(get_setting "compiled_binary")
CONFIG_REF_PREFIX=$(get_setting "ref_prefix")
CONFIG_REF_SUFFIX=$(get_setting "ref_suffix")
CONFIG_DEFAULT_LOOPS=$(get_setting "default_loops")

# --- 5. Basic Sanity Check ---
# Abort if a critical setting is completely missing from both JSON files
if [ -z "$CONFIG_COMPILATOR" ] || [ -z "$CONFIG_REF_PREFIX" ]; then
    echo "Error: Critical settings are missing. Please check your default_settings.json" >&2
    exit 1
fi