from flask import Flask, render_template

app = Flask(__name__)

@app.route('/<ip>')
def index(ip):
    #conn = psycopg2.connect(host="localhost",database="suppliers", user="postgres", password="")
    return render_template('index.html',ip=ip)

@app.route('/cakes')
def cakes():
    return 'Yummy cakes!'    

if __name__ == '__main__':
    app.run(debug=True, port=5555, host='0.0.0.0') # para pruebas desde el host se accede por el puerto 5555, luego cambiarlo al 80 ya que así se deifinió en el haproxy