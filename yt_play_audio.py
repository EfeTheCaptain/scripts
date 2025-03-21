import subprocess
import json
import sys
import os
import tempfile

def run_subprocess(command, check=True):
    """Run a subprocess and return the completed process."""
    return subprocess.run(command, capture_output=True, text=True, check=check)

def get_audio_url(title):
    """Fetch the best audio URL from YouTube using yt-dlp."""
    try:
        process = run_subprocess(["yt-dlp", "-j", "-f", "bestaudio/best", f"ytsearch:{title}"])
        results = json.loads(process.stdout.strip())
        return results[0]["url"] if isinstance(results, list) and results else None
    except (subprocess.CalledProcessError, json.JSONDecodeError, KeyError, IndexError) as e:
        print(f"Error fetching audio URL: {e}", file=sys.stderr)
        return None

def download_and_play_audio(url):
    """Download audio from the given URL and play it."""
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as temp_audio:
        temp_audio_path = temp_audio.name
    
    try:
        run_subprocess(["yt-dlp", "-x", "--audio-format", "wav", "-o", temp_audio_path, url])
        run_subprocess(["mpv", temp_audio_path])
    except subprocess.CalledProcessError as e:
        print(f"Error playing audio: {e}", file=sys.stderr)
    finally:
        if os.path.exists(temp_audio_path):
            os.remove(temp_audio_path)

def play_audio(title):
    """Fetch, download, and play audio by title."""
    audio_url = get_audio_url(title)
    if audio_url:
        download_and_play_audio(audio_url)
    else:
        print(f"No results found for \"{title}\".", file=sys.stderr)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python play_audio.py \"audio title\"", file=sys.stderr)
        sys.exit(1)
    play_audio(sys.argv[1])
