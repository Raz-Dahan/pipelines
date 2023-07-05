from flask import Flask, render_template
import requests

app = Flask(__name__)

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

    # Render the template with crypto prices
    return render_template('index.html', bitcoin_price=bitcoin_price, ethereum_price=ethereum_price, litecoin_price=litecoin_price)

if __name__ == '__main__':
    app.run(debug=True, port=80)
