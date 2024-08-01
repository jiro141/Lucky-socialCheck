from flask import Flask, jsonify, request
from telegram_service import get_telegram_updates
from twitter_service import get_twitter_user_info, get_twitter_user_tweets, get_retweeted_by, get_quote_tweets
from dotenv import load_dotenv
import os

load_dotenv()  # Load environment variables from .env file

app = Flask(__name__)

@app.route('/telegram/updates', methods=['GET'])
def telegram_updates():
    updates = get_telegram_updates()
    return jsonify(updates)

@app.route('/twitter/user_info', methods=['GET'])
def twitter_user_info():
    user_info = get_twitter_user_info()
    return jsonify(user_info)

@app.route('/twitter/user_tweets', methods=['GET'])
def twitter_user_tweets():
    user_tweets = get_twitter_user_tweets()
    return jsonify(user_tweets)

@app.route('/twitter/tweets/<tweet_id>/retweeted_by', methods=['GET'])
def twitter_retweeted_by(tweet_id):
    retweeted_by = get_retweeted_by(tweet_id)
    return jsonify(retweeted_by)

@app.route('/twitter/tweets/<tweet_id>/quote_tweets', methods=['GET'])
def twitter_quote_tweets(tweet_id):
    quote_tweets = get_quote_tweets(tweet_id)
    return jsonify(quote_tweets)

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)
