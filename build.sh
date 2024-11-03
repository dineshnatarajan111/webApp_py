#!/bin/bash
HOME_DIR=$(pwd)
DEST_DIR="./webapp_deployment"
REPO_URL="https://github.com/dineshnatarajan111/webapp_deployment.git"

if [ -d "$DEST_DIR/.git" ]; then
    echo "Directory exists. Pulling latest changes..."
    cd "$DEST_DIR" || exit
    git pull origin main  # Change 'main' to your default branch if different
    cd "$HOME_DIR"

else
    echo "Directory does not exist. Cloning repository..."
    git clone "$REPO_URL" "$DEST_DIR"
fi
chmod -R 777 .
# Define the YAML file path
yaml_file="./webapp_deployment/webapp/dev/values.yaml"

# Extract the current image.tag value using awk
current_tag=$(awk -F': ' '/image:/ {found=1} found && /tag:/ {print $2; exit}' "$yaml_file" | tr -d '"')

# Check if the tag is a semantic version (e.g., 0.0.1)
if [[ ! "$current_tag" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: image.tag is not a semantic version (e.g., 0.0.1)."
  exit 1
fi

# Split the version into major, minor, and patch
IFS='.' read -r major minor patch <<< "$current_tag"

# Increment the patch version
patch=$((patch + 1))

# Reconstruct the new version
new_tag="$major.$minor.$patch"

# Use sed to update the version in the YAML file
pattern="tag: [^ ]*"
new_val="tag: $new_tag"
sed -i.bu "s/${pattern}/${new_val}/g" "$yaml_file"

# Output the updated value
echo "Updated image.tag to: $new_tag"

docker build -t dinesh1705/webapp:$new_tag .

docker login -u $DOCKER_USR -p $DOCKER_PWD
docker push dinesh1705/webapp:$new_tag

cd "$DEST_DIR" || exit
git add "./webapp/dev/values.yaml"
git commit -m "updated version $new_tag"
git push origin main