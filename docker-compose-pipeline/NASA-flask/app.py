from flask import Flask, render_template, request
from datetime import date
import requests
import os
from dotenv import load_dotenv
from redis import Redis

load_dotenv()
redis = Redis(host='redis', port=6379)

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    logo_url = "nasaLogo.png"
    icon_url = "nasaICON.png"
    today_data = get_nasa_image(date.today().strftime("%Y-%m-%d"))
    redis.hincrby('entrance_count', 'total', 1)
    count = redis.hget('entrance_count', 'total').decode('utf-8')

    if request.method == 'POST':
        request_date = request.form['date']
        image_url = get_nasa_image(request_date)['url']
        return render_template('index.html', image_url=image_url, today_image_url=today_data['url'],today_describe_url=today_data['title'], logo_url=logo_url, icon_url=icon_url, count=int(count))
    else:
        return render_template('index.html', today_image_url=today_data['url'],today_describe_url=today_data['title'], logo_url=logo_url, icon_url=icon_url, count=int(count)) 

def get_nasa_image(date):
    secret_key = os.getenv('API_KEY')
    url = f'https://api.nasa.gov/planetary/apod?api_key={secret_key}&date={date}'
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        if 'url' in data:
            return data
    return None

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0")
