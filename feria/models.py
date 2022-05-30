# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Producto(models.Model):
    id = models.BigAutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    precio = models.DecimalField(max_digits=9, decimal_places=2)

    def __str__(self):
        return self.nombre

    class Meta:
        managed = False
        db_table = 'productos'


class Puesto(models.Model):
    id = models.BigAutoField(primary_key=True)
    descripcion = models.CharField(max_length=100)

    def __str__(self):
        return f"Puesto: {self.id} | Agricultor: {self.agricultor.nombre}"

    class Meta:
        managed = False
        db_table = 'puestos'


class Agricultor(models.Model):
    id = models.IntegerField(primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido = models.CharField(max_length=100)
    id_puesto = models.OneToOneField('Puesto', models.CASCADE, db_column='id_puesto')

    def __str__(self):
        return self.nombre

    class Meta:
        managed = False
        db_table = 'agricultores'
        verbose_name_plural = "Agricultores"


class PuestoProductos(models.Model):
    id = models.BigAutoField(primary_key=True)
    id_puesto = models.ForeignKey('Puesto', models.CASCADE, db_column='id_puesto')
    id_producto = models.ForeignKey(Producto, models.CASCADE, db_column='id_producto')

    class Meta:
        managed = False
        db_table = 'puesto_productos'


class Venta(models.Model):
    id = models.BigAutoField(primary_key=True)
    id_producto = models.ForeignKey(Producto, models.CASCADE, db_column='id_producto')
    id_puesto = models.ForeignKey(Puesto, models.CASCADE, db_column='id_puesto')

    def __str__(self):
        return f"Venta N°:{self.id}"

    class Meta:
        managed = False
        db_table = 'ventas'
