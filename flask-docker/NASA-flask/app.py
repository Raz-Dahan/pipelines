from flask import Flask, render_template, request
from datetime import date
import requests
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    logo_url = "nasaLogo.png"
    icon_url = "nasaICON.png"
    today_data = get_nasa_image(date.today().strftime("%Y-%m-%d"))

    if request.method == 'POST':
        request_date = request.form['date']
        image_url = get_nasa_image(request_date)['url']
        return render_template('index.html', image_url=image_url, today_image_url=today_data['url'],today_describe_url=today_data['title'], logo_url=logo_url, icon_url=icon_url)
    else:
        return render_template('index.html', today_image_url=today_data['url'],today_describe_url=today_data['title'], logo_url=logo_url, icon_url=icon_url) 
#     logo_url = "nasaLogo.png"
#     if request.method == 'POST':
#         request_date = request.form['date']
#         image_url = get_nasa_image(request_date)
#         today_image_url = get_nasa_image(date.today().strftime("%Y-%m-%d"))
#         today_describe_url = get_nasa_image(date.today().strftime("%Y-%m-%d"))
#         return render_template('index.html', image_url=image_url, today_image_url=today_image_url['url'],today_describe_url=today_describe_url['title'], logo_url=logo_url)
#     else:
#         today_image_url = get_nasa_image(date.today().strftime("%Y-%m-%d"))
#         today_describe_url = get_nasa_image(date.today().strftime("%Y-%m-%d"))
#         return render_template('index.html', today_image_url=today_image_url['url'],today_describe_url=today_describe_url['title'], logo_url=logo_url) 

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
    app.run(debug=True)
