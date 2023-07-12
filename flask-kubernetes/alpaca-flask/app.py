from flask import Flask, render_template
import os
from redis import Redis
import random

app = Flask(__name__)
redis = Redis(host='redis', port=6379)

# List of alpaca images
images = [
    "https://thumbs.gfycat.com/GivingTanBlackrhino-size_restricted.gif",
    "https://media.tenor.com/OZLXGyrE6FYAAAAM/alpaca-eating.gif",
    "https://media0.giphy.com/media/3otWpNrbfVfVgyAOis/200w.gif?cid=6c09b952recmr8nlic7m1swn2vl11l5rchuo1v4eup5bwpia&ep=v1_gifs_search&rid=200w.gif&ct=g",
    "https://media3.giphy.com/media/7mMm4rmb9p9oc1Ygcr/giphy.gif?cid=6c09b952ea1a2cb6e890147fd0fe7da6efac8ad1e180c1b9&ep=v1_internal_gifs_gifId&rid=giphy.gif&ct=g",
    "https://media.tenor.com/rx3nSfjUDb8AAAAM/funny-alpacas.gif",
    "https://gifdb.com/images/thumbnail/alpacas-group-gathering-xoqz5xd88ljparza.gif",
    "https://media1.giphy.com/media/DpKnKKk3IYwvByL0RJ/200w.gif?cid=6c09b952cpmw0piop84kvcvg7vbk58vj6b3c5so3g80a8wgx&ep=v1_gifs_search&rid=200w.gif&ct=g",
    "https://media3.giphy.com/media/1B4SqFFISKWdL0W0Vb/giphy.gif",
    "https://thumbs.gfycat.com/AccomplishedInfatuatedBaiji-size_restricted.gif",
    "https://media.tenor.com/4Htrx8dCwzoAAAAM/flirt-wink.gif",
    "https://i.chzbgr.com/full/8109056512/hE15FF30C/being-a-baby-alpaca-is-tiring",
]

@app.route("/")
def index():
    redis.hincrby('entrance_count', 'total', 1)
    count = redis.hget('entrance_count', 'total').decode('utf-8')
    url = random.choice(images)
    return render_template("index.html", url=url, count=int(count))



if __name__ == "__main__":
    app.run(host="0.0.0.0")
