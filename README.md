
Instalar wheel **antes** de los requerimientos con pip

Comando: pip install wheel

requirements.txt - archivo con los requerimientos necesarios

resetMigrations.sh - archivo de shell para reiniciar las migraciones 

Instalar requerimientos:
- pip install -r requirements.txt

Para iniciar el proyecto, luego de instalar las dependencias, se necesita:

- Correr el script en la base de datos

- Ejecutar resetMigrations

- Posicionarse en el directorio raiz del proyecto y ejecutar:
    python3 manage.py createsuperuser

- Seguir los pasos para crear un super usuario y lograr utilizar el sistema

