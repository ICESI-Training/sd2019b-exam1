from flask import Flask, abort
from flask_sqlalchemy import SQLAlchemy
from models import db

app = Flask(__name__)
db = SQLAlchemy()

POSTGRES = {
        'user': 'postgres',
        'pw':'password',
        'db':'ds_database',
        'host': 'localhost',
        'port': '5432',


        }

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://%(user)s:\%(pw)s@%(host)s:%(port)s/%(db)s' % POSTGRES

db.init_app(app)

api_url = '/api'


@app.route(api_url+'/books', methods=['GET'])
def read_book():
    return 'read all books'


@app.route(api_url+'/books', methods=['POST'])
def create_book():
    return 'create one book'


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080,debug='True')
    
