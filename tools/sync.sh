#!/bin/bash

# Set your dev.to API key
API_KEY=$DEV_TO_API_KEY

# Directory containing your Jekyll posts
POSTS_DIR="_posts"

# Dry run flag
DRY_RUN=true

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
  --dry-run) DRY_RUN=true ;;
  *)
    echo "Unknown parameter passed: $1"
    exit 1
    ;;
  esac
  shift
done

# Function to check if an article with the same title already exists
check_if_article_exists() {
  local title="$1"
  local response=$(curl -s -X GET "https://dev.to/api/articles/me" \
    -H "api-key: $API_KEY")
  echo "$response" | jq -r --arg title "$title" '.[] | select(.title == $title) | .id'
}

# Loop through each markdown file in the _posts directory
for file in $POSTS_DIR/*.md; do
  # Extract front matter using awk
  title=$(awk -F': ' '/^title:/ {print $2}' "$file")
  tags=$(awk -F': ' '/^tags:/ {print $2}' "$file")
  canonical_url=$(awk -F': ' '/^canonical_url:/ {print $2}' "$file")

  # Check if an article with the same title already exists
  existing_article_id=$(check_if_article_exists "$title")

  if [ -n "$existing_article_id" ]; then
    echo "Skipping $file - Article with title '$title' already exists (ID: $existing_article_id)"
    continue
  fi

  # Extract the markdown content (excluding the front matter)
  content=$(awk '/---/{flag++;next}flag==2' "$file")

  # Create a JSON payload for the dev.to API
  json_payload=$(jq -n \
    --arg title "$title" \
    --arg content "$content" \
    --arg canonical_url "$canonical_url" \
    --arg tags "$tags" \
    '{article: {title: $title, body_markdown: $content, canonical_url: $canonical_url, tags: $tags | split(", ")}}')

  # Dry run: Print the payload instead of posting
  if [ "$DRY_RUN" = true ]; then
    echo "Dry run: Would post the following article to dev.to:"
    echo "Title: $title"
    echo "Canonical URL: $canonical_url"
    echo "Tags: $tags"
    echo "Content:"
    echo "$content"
    echo "JSON Payload:"
    echo "$json_payload"
    echo "----------------------------------------"
  else
    # Post the article to dev.to
    response=$(curl -s -X POST "https://dev.to/api/articles" \
      -H "Content-Type: application/json" \
      -H "api-key: $API_KEY" \
      -d "$json_payload")

    # Check if the post was successful
    if echo "$response" | grep -q '"id":'; then
      echo "Successfully posted: $title"
    else
      echo "Failed to post: $title"
      echo "Response: $response"
    fi
  fi
done
