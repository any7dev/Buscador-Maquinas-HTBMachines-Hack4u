# BUSCADOR DE :computer: MÁQUINAS :computer: RESUELTAS POR S4VITAR

Ejercicio que forma parte de la academia [Hack4U](https://hack4u.io/) que consiste en crear un script en bash para usar varios parámetros y generar 
los resultados a partir de la web [HTB Machines](https://htbmachines.github.io/) donde se aloja toda la información de las diferentes máquinas resueltas
por [s4vitar](https://github.com/s4vitar).

Este script está basado en las clases correspondientes y se ha añadido:
- El archivo con la información de las máquinas se crea como oculto para que no sea visible por el usuario.
- Un listado ordenado alfabéticamente de las máquinas con un contador.
- Si el archivo no está actualizado, al hacerlo te indica la cantidad de máquinas nuevas.
- Las búsquedas se pueden hacer tanto en mayúsculas como en minísculas (salvo en la búsqueda por nombre).
- Se ha añadido la búsqueda por certificaciones.
- Se ha añadido el modo ataque que te crea en el directo del usuario una carpeta con el nombre de la máquina indicada y te copia en el
portapapeles su IP para comenzar el reconocimiento. Si se añade al ejecutar `&& cd ~/Nombre de la máquina` te situará dentro de él.

### USO
1. `git clone git@github.com:any7dev/Buscador-Maquinas-HTBMachines-Hack4u.git`
2. `cd Buscador-Maquinas-HTBMachines-Hack4u`
3. `chmod +x buscador.sh`
4. `.\buscador.sh`
Con esto se accede al panel de ayuda con todas las opciones disponibles.    
  
###### *Se agradece cualquier sugerencia, mejora o corrección*:memo: 




