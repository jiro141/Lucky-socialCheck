import requests
import json
from requests_oauthlib import OAuth1
import os
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv('API_KEY')
API_SECRET_KEY = os.getenv('API_SECRET_KEY')
ACCESS_TOKEN = os.getenv('ACCESS_TOKEN')
ACCESS_TOKEN_SECRET = os.getenv('ACCESS_TOKEN_SECRET')

auth = OAuth1(API_KEY, API_SECRET_KEY, ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
user_info_url = "https://api.twitter.com/2/users/me"

def get_twitter_user_info():
    response = requests.get(user_info_url, auth=auth)
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": response.status_code, "message": response.json()}

def get_twitter_user_tweets():
    user_info = get_twitter_user_info()
    if "error" in user_info:
        return user_info
    
    user_id = user_info["data"]["id"]
    user_tweets_url = f"https://api.twitter.com/2/users/{user_id}/tweets"
    params = {
        "max_results": 100,
        "tweet.fields": "created_at,author_id,text,public_metrics"
    }
    response = requests.get(user_tweets_url, auth=auth, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": response.status_code, "message": response.json()}

def get_retweeted_by(tweet_id):
    retweeted_by_url = f"https://api.twitter.com/2/tweets/{tweet_id}/retweeted_by"
    response = requests.get(retweeted_by_url, auth=auth)
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": response.status_code, "message": response.json()}

def get_quote_tweets(tweet_id):
    quote_tweets_url = f"https://api.twitter.com/2/tweets/{tweet_id}/quote_tweets"
    response = requests.get(quote_tweets_url, auth=auth)
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": response.status_code, "message": response.json()}
