import subprocess
import json
import sys
import os

def play_audio(title):
    try:
        process = subprocess.run(
            ["yt-dlp", "-j", "-f", "bestaudio/best", f"ytsearch:{title}"],
            capture_output=True,
            text=True,
            check=True,
        )
        json_output = json.loads(process.stdout)
        video_url = json_output[0]["url"] #get the url of the best video or audio stream.
        temp_audio_file = "temp_audio.wav"

        # Download the audio using ffmpeg
        subprocess.run(
            ["yt-dlp", "-x", "--audio-format", "wav", "-o", temp_audio_file, video_url],
            check=True,
        )

        # Play the audio with mpv
        subprocess.run(["mpv", temp_audio_file], check=True)

        # Clean up the temporary audio file
        os.remove(temp_audio_file)

    except subprocess.CalledProcessError as e:
        if e.returncode == 1:
            print(f"yt-dlp failed to find or download audio for \"{title}\".", file=sys.stderr)
        else:
            print(f"yt-dlp error: {e}", file=sys.stderr)
    except (json.JSONDecodeError, KeyError, IndexError) as e:
        print(f"Error processing yt-dlp output for \"{title}\": {e}", file=sys.stderr)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python play_audio.py \"audio title\"", file=sys.stderr)
        sys.exit(1)
    play_audio(sys.argv[1])
