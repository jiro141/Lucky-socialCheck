import requests
import time
import json
import os
from dotenv import load_dotenv

load_dotenv()

BOT_TOKEN = os.getenv('BOT_TOKEN')
group_id = int(os.getenv('GROUP_ID'))
url = f'https://api.telegram.org/bot{BOT_TOKEN}/getUpdates'
lucky_count = 0

def get_updates(offset=None):
    params = {'offset': offset} if offset else {}
    response = requests.get(url, params=params)
    return response.json()

def process_updates(data):
    global lucky_count
    results = []
    if data['ok']:
        if data['result']:
            for result in data['result']:
                if 'message' in result:
                    message = result['message']
                    chat = message['chat']
                    if chat['id'] == group_id:
                        text = message.get('text', '')
                        if '#lucky' in text:
                            lucky_count += 1
                        user_id = message['from']['id']
                        user_name = message['from'].get('username', 'N/A')
                        result_entry = {
                            'user_id': user_id,
                            'user_name': user_name,
                            'message': text,
                            'group_id': chat['id']
                        }
                        results.append(result_entry)
    return results

def get_telegram_updates():
    offset = None
    while True:
        data = get_updates(offset)
        if data['result']:
            offset = data['result'][-1]['update_id'] + 1
        filtered_messages = process_updates(data)
        if filtered_messages:
            return {
                "messages": filtered_messages,
                "total_lucky_messages": lucky_count
            }
        time.sleep(10)  # Wait 10 seconds before the next check
