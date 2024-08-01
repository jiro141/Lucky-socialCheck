# Microservice for Telegram and Twitter Integration

## Overview
This microservice provides endpoints to:
- Fetch Telegram group messages containing a specific hashtag.
- Fetch Twitter user information and tweets.
- Fetch retweets and quote tweets for a given tweet ID.

## Features
- Fetch updates from a specified Telegram group.
- Retrieve user information and tweets from Twitter.
- Retrieve users who retweeted and quoted a specific tweet.

## Prerequisites
- Python 3.8+
- Twitter Developer Account with API keys
- Telegram Bot Token and Group ID

## Installation

1. **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd microservice
    ```

2. **Create a virtual environment:**
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```

3. **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4. **Set up environment variables:**
    Create a `.env` file in the root directory and add your Telegram and Twitter credentials:
    ```plaintext
    # .env

    # Telegram Bot
    BOT_TOKEN=your_telegram_bot_token
    GROUP_ID=your_telegram_group_id

    # Twitter API
    API_KEY=your_twitter_api_key
    API_SECRET_KEY=your_twitter_api_secret_key
    ACCESS_TOKEN=your_twitter_access_token
    ACCESS_TOKEN_SECRET=your_twitter_access_token_secret
    ```

## Usage

1. **Run the Flask application:**
    ```bash
    python app.py
    ```

2. **API Endpoints:**

    - **Get Telegram updates:**
        ```http
        GET /telegram/updates
        ```

        Example Response:
        ```json
        {
            "messages": [
                {
                    "user_id": 123456789,
                    "user_name": "username",
                    "message": "#lucky message text",
                    "group_id": -1002184525004
                }
            ],
            "total_lucky_messages": 1
        }
        ```

    - **Get Twitter user info:**
        ```http
        GET /twitter/user_info
        ```

        Example Response:
        ```json
        {
            "data": {
                "id": "user_id",
                "name": "User Name",
                "username": "username"
            }
        }
        ```

    - **Get Twitter user tweets:**
        ```http
        GET /twitter/user_tweets
        ```

        Example Response:
        ```json
        {
            "data": [
                {
                    "id": "tweet_id",
                    "text": "Tweet text",
                    "created_at": "timestamp"
                }
            ]
        }
        ```

    - **Get users who retweeted a tweet:**
        ```http
        GET /twitter/tweets/<tweet_id>/retweeted_by
        ```

        Example Response:
        ```json
        {
            "data": [
                {
                    "id": "user_id",
                    "name": "User Name",
                    "username": "username"
                }
            ]
        }
        ```

    - **Get quote tweets:**
        ```http
        GET /twitter/tweets/<tweet_id>/quote_tweets
        ```

        Example Response:
        ```json
        {
            "data": [
                {
                    "id": "tweet_id",
                    "text": "Quote tweet text",
                    "created_at": "timestamp"
                }
            ]
        }
        ```

## Notes
- Ensure your `.env` file is added to `.gitignore` to keep your credentials secure.
- Follow the rate limits specified by Twitter's API to avoid being rate-limited.


