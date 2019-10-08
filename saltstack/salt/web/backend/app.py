from flask import Flask, request, flash, render_template
from models import db
from models import User
from flask_sqlalchemy import SQLAlchemy
app = Flask(__name__)

POSTGRES = {
    'user': 'postgres',
    'pw': 'postgres',
    'db':'ds_database',
    'host': '192.168.50.130',
    'port': '5432',
}

app.config['DEBUG'] = True
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@192.168.50.130:5432/ds_database'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False # silence the deprecation warning
app.config['SECRET_KEY'] = 'ds4ever'
db.init_app(app)
api_url = '/api'




@app.route("/")
def home():
    return render_template("front.html")


@app.route(api_url+'/users', methods=['GET'])
def read_user():
       # return User.query.all()[0].name
        return render_template('front.html', users=User.query.all())


@app.route(api_url+'/users', methods=['POST'])
def create_user():
        user=User(request.form['id'], request.form['name'])
        db.session.add(user)
        db.session.commit()
        flash('Record was successfully added')
      #  return 'create one users'
        return render_template('front.html')

if __name__ == "__main__":
    app.run()
    
