from flask import Flask, render_template
import requests
from redis import Redis

app = Flask(__name__)
redis = Redis(host='redis', port=6379)

@app.route('/')
def index():
    # Fetch crypto prices from API
    api_url = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin&vs_currencies=usd"
    response = requests.get(api_url)
    prices = response.json()
    # Extract crypto prices
    bitcoin_price = prices['bitcoin']['usd']
    ethereum_price = prices['ethereum']['usd']
    litecoin_price = prices['litecoin']['usd']
    # Get entrance count
    redis.hincrby('entrance_count', 'total', 1)
    count = redis.hget('entrance_count', 'total').decode('utf-8')
    # Assets
    background_url = "background.png"
    logo_url = "logo.png"
    return render_template('index.html', bitcoin_price=bitcoin_price, ethereum_price=ethereum_price, litecoin_price=litecoin_price, background_url=background_url, logo_url=logo_url, count=int(count))

if __name__ == '__main__':
    app.run(host="0.0.0.0")
