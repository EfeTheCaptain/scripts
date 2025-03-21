import subprocess
import json
import sys

def play_audio(title):
    try:
        process = subprocess.run(
            ["yt-dlp", "-j", "-f", "bestaudio", f"ytsearch:{title}"],
            capture_output=True,
            text=True,
            check=True,
        )
        json_output = json.loads(process.stdout)
        url = json_output[0]["url"]
        subprocess.run(["mpv", url])
    except subprocess.CalledProcessError as e:
        if e.returncode == 1:
            print(f"yt-dlp failed to find or download audio for \"{title}\".",file=sys.stderr)
        else:
            print(f"yt-dlp error: {e}",file=sys.stderr)
    except (json.JSONDecodeError, KeyError) as e:
        print(f"yt-dlp found results, but no audio URL was available for \"{title}\". Error: {e}",file=sys.stderr)
    except IndexError:
        print(f"No results found for \"{title}\".",file=sys.stderr)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python play_audio.py \"audio title\"",file=sys.stderr)
        sys.exit(1)
    play_audio(sys.argv[1])
