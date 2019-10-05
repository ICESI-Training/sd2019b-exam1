from flask import Flask, render_template
import psycopg2
import pgdb

app = Flask(__name__)

@app.route('/')
def index():
    
    hostname = '192.168.50.14' 
    username = 'postgres' 
    password = 'postgres' 
    database = 'db_distribuidos'
    
    print("Using psycopg2…")
    myConnection = psycopg2.connect( host=hostname, user=username, password=password, dbname=database ) 
    doQuery( myConnection ) 
    myConnection.close() 

    print("Using PyGreSQL…") 
    myConnection = pgdb.connect( host=hostname, user=username, password=password, database=database ) 
    doQuery( myConnection ) 
    myConnection.close()
    
    
    conn = psycopg2.connect(host="192.168.50.14",database="minions", user="postgres", password="postgres")
    return render_template('index.html')

def doQuery( conn ): 
        cur = conn.cursor() 
        cur.execute( "SELECT * FROM minions" ) 
        for cc, nombre, apellido in cur.fetchall() : 
            print(cc+" "+nombre+" "+apellido) 

@app.route('/<holi>')
def cakes(holi):
    return render_template('index.html',holi=holi)

if __name__ == '__main__':
    #app.run(port=5555)

    hostname = '192.168.50.14' 
    username = 'postgres' 
    password = 'postgres' 
    database = 'db_distribuidos'
    
    print("Using psycopg2…")
    myConnection = psycopg2.connect( host=hostname, user=username, password=password, dbname=database ) 
    doQuery( myConnection ) 
    myConnection.close() 

    print("Using PyGreSQL…") 
    myConnection = pgdb.connect( host=hostname, user=username, password=password, database=database ) 
    doQuery( myConnection ) 
    myConnection.close()