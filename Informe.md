
# Informe

Resolucion del TP 2 de la materia Técnicas de Programación Concurrentes I.

Grupo:
Gonzalo Leonel Petraglia 97811
------------>>>>>>>>>><<<<<<<<---------

## Analisis

---------->>>>>>>>>>>><<<<<<<<<<<<<----------





## 1. Procesos
La implementación brindada consta de 3 procesos:

 1. La shell del cliente
 1. La shell del servidor
 1. El servidor

### La shell del cliente

Esta shell estrictamente es la shell del programa erl la cual cumple la función de permitir hacer las llamadas al servidor mediante las funciones provistas en el modulo db_client.


### La shell del servidor

Esta shell tambien es la shell del programa erl y cumple la funcion de permitir la administración (iniciar y detener) del servidor mediante las funciones provistas en el modulo db_server.

### El servidor

Este es el proceso que recibe los mensajes y administra la base de datos.


## 2. Esquema de comunicación

La comunicación entre los procesos se da solamente entre el servidor y la shell cliente, y entre el servidor y la shell del servidor.

En el primer caso la comunicación debe ser bidireccional e iniciada por el cliente, por lo que el cliente debe enviar un identificador propio para que el servidor pueda responder. Obviamente, el cliente tambien debe enviar la operación a realizar.

En el segundo caso la comunicación puede ser unidireccional, ya que solo es necesaria para que la shell pueda parar el servidor.

## 3. Protocolo de comunicación

El cliente enviara al servidor mensajes a través del operador ! donde el mensaje esta formado por una tupla donde el primer elemento es el PID del cliente y el segundo (y último) elemento es la operación. Luego, el servidor enviara la respuesta mediante el mismo operador al PID recibido.

Las operaciones posibles y sus respuestas son las siguientes:

### Add

El esquema basico del mensaje de la operación add es el de una tupla donde el primer elemento es el atomo add y el segundo (y último) elemento es la tupla a agregar.
Ejemplo:

> {add, {"Gonzalo", "Corrientes 223", "4444"}}

La respuesta puede ser el átomo ok o una tupla formada por el átomo error y el error.
Ejemplo:

> {error, "Duplicated entry"}

### Select

El esquema básico del mensaje de la operacion select es el de una tupla de dos elementos, siendo el primero el átomo select y el segundo los filtros a aplicar.
Ejemplo:

> {get, [{address, "Corrientes 223"}, {name, "Gonzalo"}]}

La respuestas posibles son similares a la de la operación add.



## Diagramas de clases

No existe un diagrama de clases dada la naturaleza funcional de erlang, se da un diagrama de modulos.

----->>>>>>>>>>><<<<<<<<<<<<<<<<<<---------
