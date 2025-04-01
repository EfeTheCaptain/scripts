import requests
import re
from datetime import datetime, timedelta

def get_prayer_times(url="https://namazvakitleri.diyanet.gov.tr/tr-TR/9543/kucukcekmece-icin-namaz-vakti"):
    response = requests.get(url)

    if response.status_code != 200:
        return "Failed to retrieve the page."

    prayer_times = {
        match[0]: match[1]
        for match in re.findall(r'var _(\w+)Time = "(\d{2}:\d{2})";', response.text)
    }

    formatted_prayer_names = {
        "imsak": "İmsak",
        "gunes": "Güneş",
        "ogle": "Öğle",
        "ikindi": "İkindi",
        "aksam": "Akşam",
        "yatsi": "Yatsı"
    }

    prayer_output = "\n".join(
        f"{formatted_prayer_names[key]}: {value}" for key, value in prayer_times.items()
    )

    hijri_date_match = re.search(r'<div class="ti-hicri">(.*?)<\/div>', response.text)
    miladi_date_match = re.search(r'<div class="ti-miladi">(.*?)<\/div>', response.text)

    hijri_date = f"Hijri Date: {hijri_date_match.group(1).strip()}" if hijri_date_match else "Hijri date not found."
    miladi_date = f"Miladi Date: {miladi_date_match.group(1).strip()}" if miladi_date_match else "Miladi date not found."

    # Calculate remaining time
    now = datetime.now()
    remaining_time = "Could not determine remaining time."

    next_prayer_time = None
    for key, value in prayer_times.items():
        prayer_time = datetime.strptime(value, "%H:%M").replace(year=now.year, month=now.month, day=now.day)
        if prayer_time > now:
            time_left = prayer_time - now
            remaining_time = f"Time left until {formatted_prayer_names[key]}: {str(time_left).split('.')[0]}"
            next_prayer_time = prayer_time
            break

    # Handle the case where all prayer times have passed (after Yatsı)
    if next_prayer_time is None:
        # Get the first prayer time of the next day (Imsak).
        imsak_time_str = prayer_times["imsak"]
        imsak_time = datetime.strptime(imsak_time_str, "%H:%M").replace(year=now.year, month=now.month, day=now.day) + timedelta(days=1)
        time_left = imsak_time - now
        remaining_time = f"Time left until {formatted_prayer_names['imsak']} (Tomorrow): {str(time_left).split('.')[0]}"

    notification_text = f"{prayer_output}\n\n{hijri_date}\n{miladi_date}\n\n{remaining_time}"
    return notification_text

if __name__ == "__main__":
    result = get_prayer_times()
    print(result)
