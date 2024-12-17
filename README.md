# Documentation Scraper

A bash script for downloading and extracting text content from documentation websites for LLMs. The script crawls documentation pages, converts HTML content to plain text, and combines everything into a single file suitable for processing with LLMs or other text analysis tools.

## Features

- Downloads all documentation pages from a given starting URL
- Converts HTML to plain text while preserving readability
- Combines all documentation into a single text file
- Preserves section structure with clear separators
- Automatically cleans up temporary files
- Works with any documentation site following standard URL patterns

## Prerequisites

The script requires the following tools to be installed:

- `wget` for downloading web pages
- `lynx` for converting HTML to text

### Installation on macOS
```bash
brew install wget lynx
```

### Installation on Ubuntu/Debian
```bash
sudo apt-get install wget lynx
```

## Usage

1. Download the script:
```bash
wget https://raw.githubusercontent.com/creaoy/doc-scraper-for-llm/main/scrape_docs.sh
```

2. Make it executable:
```bash
chmod +x scrape_docs.sh
```

3. Run the script with a documentation URL:
```bash
./scrape_docs.sh https://domain.com/project/docs/intro/
```

The script will create a text file named after the project (e.g., `project_documentation.txt`).

## Example

```bash
./scrape_docs.sh https://ai16z.github.io/eliza/docs/intro/
```

This will create `eliza_documentation.txt` containing all the documentation content.

## Output Format

The output file contains:
- Section separators showing the source of each content block
- Plain text content with preserved structure
- Clear spacing between different documentation pages

## Error Handling

The script includes several safety checks:
- Verifies required tools are installed
- Checks for valid URLs
- Ensures content is actually downloaded
- Validates output file creation

## Limitations

- Requires proper permissions to write to the current directory
- Works best with documentation sites using standard URL patterns
- May require adjustments for sites with unusual structures
- Does not handle JavaScript-rendered content

## Contributing

Feel free to submit issues and enhancement requests! 

## License

MIT License - feel free to use this script for any purpose.