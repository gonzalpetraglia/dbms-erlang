# dbms-erlang

Este es el TP N°2 de Técnicas de Programación Concurrentes I. En éste se implementó un pequeño gestor de base de datos, asi como también un pequeño cliente para el mismo. Ambos fueron desarrollados en **Erlang**.

## Ejecución

Para poder compilar los archivos **.erl** debemos ejecutar:

```bash
$ make
```

### Servidor

Para correr el servidor debemos, estando en la carpeta principal de este proyecto, ejecutar el siguiente comando:

```bash
$ make run-server [DBNAME='nombre del nodo del servidor'] [DBFILE='nombre archivo de salida']

	DBNAME: 'dbms' (valor default)
	DBFILE: opcional
```

Una vez hecho esto tenemos la interfaz provista para administrar el DBMS, la cual consiste de las siguientes funciones:

 - **stop(OutFile)** : Detiene el servidor que este corriendo y persiste la base de datos que se estuviera usando en el archivo OutFile.
 - **stop()** :  Detiene el servidor que este corriendo y NO persiste la base de datos que se estuviera usando.
 - **start(InFile)** : Inicia un servidor utilizando la base de datos persistida en InFile.
 - **start()** : Inicia un servidor utilizando una base de datos vacía.


### Cliente

Para correr el cliente debemos, estando en la carpeta principal de este proyecto, ejecutar el siguiente comando:

```bash
$ make run-client [CLIENTID='número de cliente']

	CLIENTID: sirve para conformar el nombre del nodo -> 'client'+CLIENTID
			Ej: client1
```

Una vez dentro de la consola de Erlang se debe definir el nodo a conectarse, lo que podemos hacer ejecutando:

> db_client:start(DBMSNode). [ver nota al final]

Una vez hecho esto tenemos la interfaz provista para administrar el DBMS, la cual consiste de las siguientes funciones:

 - **add({Name, Address, Phone})**:  Agrega la tupla dada a la base de datos.
 - **select_by_tuple({Name, Address, Phone})**: Se hace una búsqueda de los registros que coincidan con la tupla dada. Cualquier parámetro puede ser reemplazado por el átomo 'any' para que no se filtre por este campo.

 También se provee una API mas parecida a la de un ORM productivo, *SQLAlchemy*, la cual consta de las siguientes funciones:
 - **select(Filters)** : Ejecuta un select sobre la base de datos aplicando los filtros dados.
 - **filter(Field, Value, Query)**: Añade un filtro sobre el campo Field de parámetro Value a la Query dada. Field debe ser los átomos que representan a los campos de la base de datos(address, name, phone).
 - **basic_select()** : Crea un filtro vacío.

 Ejemplo de uso de esta ultima API:

> Q = filter(address, "Corrientes 3000", basic_select())
>
> Q1 = filter(phone, "4444-5555", Q)
>
> Result = select(Q1)


Nota: El nombre del nodo esta formado por el parámetro DBNAME con el que se ejecutó la consola de Erlang del servidor, un @ y el nombre del equipo donde se ejecutó la consola antes mencionada. Esta se puede ver en el prompt de la misma.
	Ej: dbms@equipo

