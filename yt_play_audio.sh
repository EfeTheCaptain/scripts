#!/bin/bash

# Prompt user to choose between audio and video
echo "Choose an option:"
echo "1. Audio"
echo "2. Video"
read -p "Enter your choice (1/2): " choice

# Validate input
if [[ "$choice" != "1" && "$choice" != "2" ]]; then
    echo "Invalid choice. Exiting."
    exit 1
fi

# Prompt user for the title
read -p "Enter the YouTube title: " title

# Get video metadata from yt-dlp
metadata=$(yt-dlp -j --no-playlist "ytsearch:$title")
url=$(echo "$metadata" | jq -r '.url')
video_title=$(echo "$metadata" | jq -r '.title')

# Validate URL
if [[ -z "$url" || "$url" == "null" ]]; then
    echo "Video not found. Exiting."
    exit 1
fi

if [[ "$choice" == "1" ]]; then
    # Use a temporary file
    temp_audio="$(mktemp --suffix=.mp3)"
    
    # Download and play audio
    yt-dlp -x --audio-format mp3 -o "$temp_audio" "$url"
    mpv --no-video "$temp_audio"
    
    # Cleanup
    rm -f "$temp_audio"
    
elif [[ "$choice" == "2" ]]; then
    # Stream video directly with mpv
    mpv --ytdl-format "bestvideo[height<=1080]+bestaudio/best" "$url"
fi
