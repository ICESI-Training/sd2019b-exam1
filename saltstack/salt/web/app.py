from flask import Flask, render_template
import psycopg2
import pgdb

app = Flask(__name__)

@app.route('/')
def index():
    connect()
    return render_template('index.html', minions=minions)

@app.route('/<holi>')
def cakes(holi):
    return render_template('index.html',holi=holi)

def doQuery( conn ): 
    cur = conn.cursor() 
    cur.execute( "SELECT * FROM minions" )
    minions = []
    for cc, nombre, apellido in cur.fetchall() : 
        minions.extend([cc,nombre,apellido])
        print(cc+" - "+nombre+" - "+apellido) # PARA PROBAR SIN PAGINA WEB DESCOMENTAR
    return minions

def connect():
    hostname = '192.168.50.14' 
    username = 'postgres' 
    password = 'postgres' 
    database = 'db_distribuidos'
    
    print("Using psycopg2…")
    myConnection = psycopg2.connect( host=hostname, user=username, password=password, dbname=database ) 
    minions = doQuery( myConnection ) 
    myConnection.close()

    #print("Using PyGreSQL…") 
    #myConnection = pgdb.connect( host=hostname, user=username, password=password, database=database ) 
    #doQuery( myConnection ) 
    #myConnection.close()

if __name__ == '__main__':
    #app.run(port=5555) # PARA PROBAR SIN PAGINA WEB COMENTAR
    connect() # PARA PROBAR SIN PAGINA WEB DESCOMENTAR