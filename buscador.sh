#!/bin/bash

#Colores
rojo="\e[1;31m\033[1m"
azul="\e[3;34m\033[1m"
amarillo="\e[0;33m\033[1m"
verde="\e[0;32m\033[1m"
finColor="\033[0m\e[0m"

#Variables
url="https://htbmachines.github.io/bundle.js"
declare -i contador=0
declare -i cantidadO=0
declare -i contadorN=0
declare -i osC=0
declare -i dC=0

function ctrl_c(){
    echo -e "\n${rojo}...Saliendo...${finColor}\n"
    exit 1
}

trap ctrl_c INT

function archivo(){
    echo -e "\nComprobando si tienes el archivo en el sistema..."
    if [ ! -f .bundle.js ]; then
        echo -e "${rojo}No lo tienes, descargando...${finColor}"
        curl -s $url > .bundle.js
        js-beautify .bundle.js | sponge .bundle.js
        echo -e "${amarillo}Archivo descargado con éxito${finColor}\n" 
    else
        echo -e "Ya tienes el archivo, comprobando si hay alguna actualización..."
        curl -s $url > .new.js
        js-beautify .new.js | sponge .new.js 
        original=$(md5sum .bundle.js | awk '{print $1}')
        nuevo=$(md5sum .new.js | awk '{print $1}')
        if [ "$original" == "$nuevo" ]; then
            echo -e "${verde}Sin actualizaciones${finColor}\n"
            rm .new.js
        else
            cantidadO=$(cat .bundle.js | grep "so: " -C 6 | grep "dificultad: " -B6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | wc -w)
            cantidadN=$(cat .new.js | grep "so: " -C 6 | grep "dificultad: " -B6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | wc -w)
            let diferencia=$cantidadN-$cantidadO
            rm .bundle.js
            mv .new.js .bundle.js
            echo -e "${amarillo}Archivo actualizado con éxito, hay $diferencia máquina/s nueva/s${finColor}\n"
        fi
    fi
}

function maquinas(){
    maquinas="$(cat .bundle.js | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | tail -n +25 | sort | column)"
    cantidad="$(cat .bundle.js | grep "so: " -C 6 | grep "dificultad: " -B6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | wc -w)"
    echo -e "\nHay un total de ${amarillo}$cantidad${finColor} máquinas y son:\n"
    echo -e "${amarillo}$maquinas${fincolor}\n"

}

function porNombre(){
    nombre="$1"
    busquedaN="$(cat .bundle.js | awk "/name: \"$nombre\"/,/resuelta/" | grep -vE "name:|id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//')"
    if [ "$busquedaN" ]; then
        echo -e "${amarillo}$busquedaN${finColor}\n"
    else
        echo -e "\n${rojo}No se ha encontrado la máquina${finColor}\n"
    fi
}

function porIP(){
    ip="$1"
    busquedaI="$(cat .bundle.js | grep "ip: \"$ip\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
    if [ "$busquedaI" ]; then
        echo -e "\nEl nombre de la máquina es ${amarillo}$busquedaI${finColor}\n"
    else
        echo -e "\n${rojo}No se ha encontrado la IP${finColor}\n"
    fi
}

function porSO(){
    so="$1"
    busquedaSO="$(cat .bundle.js | grep "so: \"$so\"" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ','  | column)"
    cantidad="$(echo $busquedaSO | wc -w)"
    if [ "$busquedaSO" ]; then
        echo -e "\nHay un total de ${amarillo}$cantidad${finColor} máquinas con este Sistema Operativo y son:\n"
        echo -e "${amarillo}$busquedaSO${finColor}\n"
    else
        echo -e "\n${rojo}No se ha encontrado el sistema operativo${finColor}\n"
    fi
}

function porDificultad(){
    dificultad="$1"
    busquedaD="$(cat .bundle.js | grep "dificultad: \"$dificultad\"" -i -B5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    cantidad="$(echo $busquedaD | wc -w)"
    if [ "$busquedaD" ]; then
        echo -e "\nHay un total de ${amarillo}$cantidad${finColor} máquinas con esta dificultad y son:\n"
        echo -e "${amarillo}$busquedaD${finColor}\n"
    else
        echo -e "\n${rojo}No se ha encontrado la dificultad${finColor}\n"
    fi
}

function porSkill(){
    skill="$1"
    busquedaSk="$(cat .bundle.js | grep "skills: " -B 7 -A 1 | grep "$skill" -w -i -B 7 -A 1 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    cantidad="$(echo $busquedaSk | wc -w)"
    if [ "$busquedaSk" ]; then
        echo -e "\nHay un total de ${amarillo}$cantidad${finColor} máquinas con esta skill y son:\n"
        echo -e "${amarillo}$busquedaSk${finColor}\n"
    else
        echo -e "\n${rojo}No se ha encontrado la skill${finColor}\n"
    fi
}

function youtube(){
    nombre="$1"
    busquedaN="$(cat .bundle.js | grep "name: \"$nombre\"" -i -A 10 | grep "youtube" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
    if [ "$busquedaN" ]; then
        echo -e "\n${amarillo}$busquedaN${fincColor}\n"
    else
        echo -e "\n${rojo}No se ha encontrado la máquina${finColor}\n"
    fi
}

function porSOyDI(){
    so="$1"
    dificultad="$2"
    busquedaSOyDI="$(cat .bundle.js | grep "so: \"$so\"" -i -C 6 | grep "dificultad: \"$dificultad\"" -i -B6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    cantidad="$(echo $busquedaSOyDI | wc -w)"
    if [ "$busquedaSOyDI" ]; then
        echo -e "\nLas máquinas encontradas con el sisteme operativo y dificultad introducidos son ${amarillo}$cantidad${finColor}:\n"
        echo -e "${amarillo}$busquedaSOyDI${fincColor}\n" 
    else
        echo -e "\n${rojo}No se ha encontrado el sistema operativo y/o la dificultad${finColor}\n"
    fi
}

function porCert(){
    cert="$1"
    busquedaCert="$(cat .bundle.js | grep "$cert" -w -i -B 10 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    cantidad="$(echo $busquedaCert | wc -w)"
    if [ "$busquedaCert" ]; then
        echo -e "\nHay un total de ${amarillo}$cantidad${finColor} máquinas con esta certificación y son:\n"
        echo -e "${amarillo}$busquedaCert${finColor}\n"
    else
      echo -e "\n${rojo}No se ha encontrado la certificación${finColor}\n"
   fi
}

function ataque(){
    nombre="$1"
    mkdir ~/$nombre
    echo -e "\nCreadro el directorio ${amarillo}~/$nombre${finColor}"
    cd ~/$nombre
    echo -e "Te he situado dentro de ese directorio"
    IP="$(cat .bundle.js | awk "/name: \"$nombre\"/,/resuelta/" | grep -vE "name:|id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "ip: " | awk 'NF{print $NF}')"
    echo $IP | xclip -sel clip
    echo -e "Tienes la IP de la máquina copiada al portapapeles\n"    
}

function ayuda(){
    echo -e "\nLos ${verde}parámetros${finColor} disponibles son:\n"
    echo -e "\t${verde}-u${finColor} Para descargar o actualizar el ${verde}archivo${finColor} con las máquinas\n"
    echo -e "\t${verde}-m${finColor} Para mostar ${verde}todas las máquinas${finColor} disponibles por orden alafbético\n"
    echo -e "\t${verde}-n${finColor} Para buscar por el ${verde}nombre${finColor} de la máquina\n"
    echo -e "\t${verde}-i${finColor} Para buscar por la ${verde}IP${finColor} de la máquina\n"
    echo -e "\t${verde}-o${finColor} Para buscar por el ${verde}sistema operativo${finColor} de la máquina\n"
    echo -e "\t${verde}-d${finColor} Para buscar por la ${verde}dificultad${finColor} de la máquina\n"
    echo -e "\t${verde}-o${finColor} ${azul}sistema operativo${finColor} ${verde}-d${finColor} ${azul}dificultad${finColor} --> Para buscar por ${verde}sistema operativo y dificultad${finColor} de la máquina\n"
    echo -e "\t${verde}-s${finColor} Para buscar por la ${verde}skill${finColor} de la máquina\n"
    echo -e "\t${verde}-y${finColor} Para mostrar el ${verde}link de Youtube${finColor} de la resolución de la máquina\n"
    echo -e "\t${verde}-c${finColor} Para buscar por ${verde}certificación${finColor}\n"
    echo -e "\t${verde}-a${finColor} ${verde}Modo Ataque${finColor} --> Te crea un directorio con el nombre de la máquina que introduzcas como argumento y te copia en el portapapeles su IP\n"
    echo -e "\t${verde}-h Ayuda${finColor}\n"
}

while getopts "umn:i:o:d:s:y:c:a:h" arg; do
    case $arg in
        u) let contador+=1;;
        m) let contador+=2;;
        n) nombre=$OPTARG; let contador+=3;;
        i) ip=$OPTARG; let contador+=4;;
        o) so=$OPTARG; osC=1; let contador+=5;;
        d) dificultad=$OPTARG; dC=1; let contador+=6;;
        s) skill=$OPTARG; let contador+=7;;
        y) nombre=$OPTARG; let contador+=8;;
        c) cert=$OPTARG; let contador+=9;;
        a) nombre=$OPTARG; let contador+=10;;
        h) ;;
    esac
done

if [ $contador -eq 1 ]; then
    archivo
elif [ $contador -eq 2 ]; then
    maquinas     
elif [ $contador -eq 3 ]; then
    porNombre $nombre 
elif [ $contador -eq 4 ]; then
    porIP $ip
elif [ $contador -eq 5 ]; then
    porSO $so     
elif [ $contador -eq 6 ]; then
    porDificultad $dificultad  
elif [ $contador -eq 7 ]; then
    porSkill $skill
elif [ $contador -eq 8 ]; then
    youtube $nombre
elif [ $osC -eq 1 ] && [ $dC -eq 1 ]; then
     porSOyDI $so $dificultad   
elif [ $contador -eq 9 ]; then
    porCert $cert
elif [ $contador -eq 10 ]; then
    ataque $nombre                  
else
    ayuda
fi
