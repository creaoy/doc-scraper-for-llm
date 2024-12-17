#!/bin/bash

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <base_url>"
    echo "Example: $0 https://ai16z.github.io/eliza/docs/intro/"
    exit 1
fi

# Check for lynx
if ! command -v lynx &> /dev/null; then
    echo "Error: lynx is not installed. Please install it first."
    echo "Use: brew install lynx  # for macOS"
    echo "  or: sudo apt-get install lynx  # for Ubuntu/Debian"
    exit 1
fi

BASE_URL="$1"
TEMP_DIR="temp_docs"

# Extract domain and path components
DOMAIN=$(echo "$BASE_URL" | awk -F/ '{print $3}')
BASE_PATH=$(echo "$BASE_URL" | awk -F "$DOMAIN" '{print $2}' | grep -o '^/[^/]*/[^/]*/')
PROJECT_NAME=$(echo "$BASE_PATH" | awk -F/ '{print $2}')

OUTPUT_FILE="${PROJECT_NAME}_documentation.txt"

echo "Starting documentation download from $BASE_URL"
echo "Output will be saved to: $OUTPUT_FILE"

# Create temporary directory
mkdir -p "$TEMP_DIR"

# First, get the main page and extract links
wget -qO- "$BASE_URL" | grep -o "href=\"[^\"]*\"" | cut -d'"' -f2 | grep "^$BASE_PATH" | sort -u > urls.txt

# Convert relative URLs to absolute
sed -i.bak "s|^|https://$DOMAIN|" urls.txt

# Download each discovered URL
while IFS= read -r url; do
    echo "Downloading: $url"
    filename=$(echo "$url" | sed 's|.*/||')
    if [ -z "$filename" ]; then
        filename="index.html"
    fi
    wget -q "$url" -O "$TEMP_DIR/${url//\//_}.html"
done < urls.txt

if [ ! -f "$OUTPUT_FILE" ]; then
    touch "$OUTPUT_FILE"
fi

echo "Converting HTML files to text..."

# Process each HTML file and convert to text using lynx
for file in "$TEMP_DIR"/*.html; do
    if [ -f "$file" ]; then
        echo "Processing: $file"
        echo "=== $file ===" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        lynx -dump -nolist "$file" >> "$OUTPUT_FILE"
        echo -e "\n\n" >> "$OUTPUT_FILE"
    fi
done

# Check if the output file has content
if [ ! -s "$OUTPUT_FILE" ]; then
    echo "Error: No content was extracted"
    rm -rf "$TEMP_DIR" urls.txt
    rm -f "$OUTPUT_FILE"
    exit 1
fi

# Clean up
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR" urls.txt urls.txt.bak

echo "Done! Documentation has been saved to $OUTPUT_FILE"
echo "Total size: $(wc -c < "$OUTPUT_FILE") bytes"