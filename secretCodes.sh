#!/bin/bash

# -----------------------------------------------------------
# Android Secret Dialer Code Extraction Tool
# Supports: --csv | --json | --quiet
# -----------------------------------------------------------

# ---------------- Defaults ----------------
EXPORT_MODE="text"   # text | csv | json
QUIET=0

# ---------------- Colors ----------------
RED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# ---------------- Banner (Help) ----------------
banner() {
    color_code=$GREEN

    echo -e "${color_code}"
    cat << "EOF"
 ⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀
 ⠀⠀⠀⠀⠀⠙⢷⣤⣤⣴⣶⣶⣦⣤⣤⡾⠋⠀⠀⠀⠀⠀
 ⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀
 ⠀⠀⠀⠀⣼⣿⣿⣉⣹⣿⣿⣿⣿⣏⣉⣿⣿⣧⠀⠀⠀⠀
 ⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀
 ⣠⣄⠀⢠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡄⠀⣠⣄
 ⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿
 ⣿⣿⡇⢸ Secret Codes ⡇⢸⣿⣿
 ⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿
 ⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿
 ⠻⠟⠁⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠈⠻⠟
 ⠀⠀⠀⠀⠉⠉⣿⣿⣿⡏⠉⠉⢹⣿⣿⣿⠉⠉⠀⠀⠀⠀
 ⠀⠀⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀
 ⠀⠀⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀
 ⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠉⠉⠁⠀
EOF
    echo -e "${RESET}"
}

# ---------------- Help Menu ----------------
show_help() {
    banner
    echo -e "${WHITE}
Usage:
  $(basename "$0") [OPTIONS]

Options:
  --csv        Export results to CSV format
  --json       Export results to JSON format
  --quiet      Suppress console output (log file only)
  --help       Show this help menu and exit

Examples:
  $(basename "$0") --csv
  $(basename "$0") --json --quiet${RESET}"
}

# ---------------- Parse Args ----------------
for arg in "$@"; do
    case "$arg" in
        --csv)      EXPORT_MODE="csv" ;;
        --json)     EXPORT_MODE="json" ;;
        --quiet)    QUIET=1 ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# ---------------- Trap Ctrl-C ----------------
trap 'echo -e "\n${WHITE}Interrupted by user${RESET}"; exit 1' INT

# ---------------- Pre-flight Checks ----------------
command -v adb >/dev/null 2>&1 || {
    echo -e "${RED}ADB not found in PATH${RESET}"
    exit 1
}

device_count=$(adb devices | grep -w device | wc -l)
if [ "$device_count" -ne 1 ]; then
    echo -e "${RED}Expected exactly one connected device, found: ${device_count}${RESET}"
    exit 1
fi

# ---------------- Timestamp & Output ----------------
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
case "$EXPORT_MODE" in
    csv)  output_file="Secret_Codes_${timestamp}.csv" ;;
    json) output_file="Secret_Codes_${timestamp}.json" ;;
    *)    output_file="Secret_Codes_${timestamp}.txt" ;;
esac

# ---------------- Device Info ----------------
man=$(adb shell getprop ro.product.manufacturer 2>/dev/null)
model=$(adb shell getprop ro.product.model 2>/dev/null)
os_ver=$(adb shell getprop ro.build.version.release 2>/dev/null)

# ---------------- Banner ----------------
show_banner() {
    [ "$QUIET" -eq 1 ] && return
    echo -e "${WHITE}============================================================${RESET}"
    echo -e "${CYAN}      ANDROID SECRET DIALER CODE EXTRACTION TOOL${RESET}"
    echo -e "${WHITE}============================================================${RESET}"
    echo -e "${WHITE} Manufacturer: ${CYAN}${man}${RESET}"
    echo -e "${WHITE} Model:        ${CYAN}${model}${RESET}"
    echo -e "${WHITE} OS Version:   ${CYAN}${os_ver}${RESET}"
    echo -e "${WHITE} Output File:  ${CYAN}${output_file}${RESET}"
    echo -e "${WHITE} Mode:         ${CYAN}${EXPORT_MODE}${RESET}"
    echo -e "${WHITE}============================================================${RESET}"
    echo
}

# ---------------- Initialize Output ----------------
init_output() {
    case "$EXPORT_MODE" in
        csv)
            echo "manufacturer,model,os_version,package,secret_code" > "$output_file"
            ;;
        json)
            cat > "$output_file" <<EOF
{
  "manufacturer": "$(echo "$man" | sed 's/"/\\"/g')",
  "model": "$(echo "$model" | sed 's/"/\\"/g')",
  "os_version": "$(echo "$os_ver" | sed 's/"/\\"/g')",
  "generated_at": "$timestamp",
  "results": [
EOF
            ;;
        *)
            : > "$output_file"
            ;;
    esac
}

# ---------------- Finalize JSON ----------------
finalize_json() {
    [ "$EXPORT_MODE" != "json" ] && return
    # Remove trailing comma if present
    sed -i '$ s/,$//' "$output_file"
    echo "  ]" >> "$output_file"
    echo "}" >> "$output_file"
}

# ---------------- Secret Code Dump ----------------
android_secret_code_dump() {

    package_name_trim=$(adb shell 'pm list packages -s -f' \
        | awk -F 'package:' '{print $2}' \
        | awk -F '=' '{print $2}')

    for pkg in ${package_name_trim}; do

        # Show package name in white if not in QUIET mode
        [ "$QUIET" -eq 0 ] && echo -e "${WHITE}${pkg}${RESET}"

        # Write package name to output file if text export mode
        [ "$EXPORT_MODE" = "text" ] && echo "$pkg" >> "$output_file"

        # Extract secret codes using original reliable method
        codes=$(adb shell pm dump "$pkg" 2>/dev/null \
            | grep -E 'Scheme: "android_secret_code"|Authority: "[0-9].*"|Authority: "[A-Z].*"' \
            | awk -F '"' '/Authority:/ {print $2}' \
            | sort -u)

        # Skip packages with no codes
        [ -z "$codes" ] && continue

        # Process each found code
        while read -r code; do
            case "$EXPORT_MODE" in
                csv)
                    echo "\"$man\",\"$model\",\"$os_ver\",\"$pkg\",\"$code\"" >> "$output_file"
                    ;;
                json)
                    cat >> "$output_file" <<EOF
{
  "package": "$(echo "$pkg" | sed 's/"/\\"/g')",
  "secret_code": "$(echo "$code" | sed 's/"/\\"/g')"
},
EOF
                    ;;
                text|*)
                    [ "$QUIET" -eq 0 ] && echo -e "  ${GREEN}${code}${RESET}"
                    echo "  $code" >> "$output_file"
                    ;;
            esac
        done <<< "$codes"

        # Add a blank line between packages in text mode
        [ "$EXPORT_MODE" = "text" ] && echo >> "$output_file"
    done
}

# ---------------- Run ----------------
show_banner
init_output

[ "$QUIET" -eq 0 ] && echo -e "${WHITE}Extracting Android secret dialer codes...${RESET}"
android_secret_code_dump
finalize_json

[ "$QUIET" -eq 0 ] && echo
[ "$QUIET" -eq 0 ] && echo -e "${GREEN}✔ Output written to: ${CYAN}${output_file}${RESET}"
