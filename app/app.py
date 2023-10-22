#
# Bolt App
#
import os
import logging
from slack_bolt import App

# from slack_bolt.adapter.socket_mode import SocketModeHandler
from slack_bolt.adapter.flask import SlackRequestHandler
from flask import Flask

logging.basicConfig(level=logging.DEBUG)

# app = App(token=os.environ["SLACK_BOT_TOKEN"])
bot_token = "xoxb-811268029777-6071567405539-FySP9p65RSi4uKbgIYJSCROt"
app = App(token=bot_token)


# Add middleware / listeners here
@app.command("/hi")
def hello(body, ack):
    user_id = body["user_id"]
    ack(f"Hi <@{user_id}>!")


#
# Web App
#
flask_app = Flask(__name__)

# You won't use the Flask adapter as all the event requests are handled by
# the above Socket Mode connection
# from slack_bolt.adapter.flask import SlackRequestHandler
handler = SlackRequestHandler(app)


@flask_app.route("/hello", methods=["GET"])
def index():
    return "Hello World"


# You can run this app by the following command:
# gunicorn --bind :3000 --workers 1 --threads 2 --timeout 0 app:flask_app
