import json

from django.http import JsonResponse, HttpResponse
from django.shortcuts import render
from django.db import connection
import csv
from django.utils.encoding import smart_str
def index(request):
    return render(request, 'feria/index.html', {})

def reporte_ventas(request):
    cursor = connection.cursor()
    cursor.execute("""select productos.nombre as producto, agricultores.nombre as 'puesto de', 
                   count(ventas.id) as 'cantidad de ventas', precio * count(ventas.id) as 'ganancias' 
                    from ventas inner join productos on productos.id=ventas.id_producto 
                    inner join agricultores on ventas.id_puesto=agricultores.id_puesto  
                   group by ventas.id_producto, ventas.id_puesto;""")
    rows = cursor.fetchall()
    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="Reporte-ventas-feria.csv"'
    writer = csv.writer(response, csv.excel)
    response.write(u'\ufeff'.encode('utf-8-sig'))
    writer.writerow([
        smart_str(u"Producto"),
        smart_str(u"Puesto de"),
        smart_str(u"Cantidad de ventas"),
        smart_str(u"Ganancias"),
    ])
    for row in list(rows):
        row = list(row)
        writer.writerow([
            smart_str(row[0]),
            smart_str(row[1]),
            smart_str(row[2]),
            smart_str(row[3]),
        ])
    return response