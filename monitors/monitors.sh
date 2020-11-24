#!/bin/bash

#################################################################################################################
# 	Script para gestionar basicamente monitores multiples mediante el uso de 				#
# 	XRANDR. Probado en mi Arch Linux.									#
# 	Autor: Jonas A. Reyes C. | 2020										#
# 	Licencia: Puedes Copiarlo, modificarlo, Distribuirlo como desees y sin					#
# 	obligacion de incluir mi nombre.									#
#	Contact: { E-Mail: jonasreyes@yandex.com | https://vk.com/jonasreyes | Telegram: @jonasreyes } 		#
#														#
#################################################################################################################

# Variables a usar:

attrOne=$1 #Primera opcion pasada al script 
attrSec=$2 #segunda opcion pasada al script

intern=eDP1 			# Pantalla del Laptop.
sizeIntern="--size 1366x768"	# Obligatoria para mi configurcion personal.
modeIntern="1366x768"			# Uso opcional para quien la necesite.
posIntern="--pos 2560x0" # Ubicare la Laptop a la Derecha

extern=HDMI1 			# Pantalla de monitor externo.
sizeExtern="--size 2560x1080"	# Variable de uso opcional
modeExtern="2560x1080" 	# Para mi caso personal es una variable de uso obligatorio, Modo xrandr redeterminado para el monitor secundario.
posExtern="--pos 0x0" # Siempre el Externo lo ubicare a la izquierda

#
# Limpiando los Modes
#
#`xrandr --delmode ${intern} ${modeIntern}`
#`xrandr --rmmode ${modeIntern}`

#`xrandr --delmode ${extern} ${modeExtern}`
#`xrandr --rmmode ${modeExtern}`

#
# Verificacion de existencia previa del Modeline
#

# Chequeamos si nuestro modo para el monitor externo ya existe, he debido crear este modo para lograr una tasa de refresco inferior a los 60Hz, para evitar el parpadeo de la pantalla

result=`xrandr | grep ${modeExtern}`
if [ "$result" == '' ]
        then
                modeExtern="2560x1080_56.00"
                xrandr --newmode "${modeExtern}" 213.25  2560 2720 2984 3408  1080 1083 1093 1118 -hsync +vsync
                xrandr --addmode ${extern} ${modeExtern}
                echo "Se ha creado en xrandr el modo ${modeExtern} para ${extern}"
		
		
		modeIntern="1366x768-0"
		xrandr --newmode "${modeIntern}" 75.61  1366 1406 1438 1574  768 771 777 800 -hsync -vsync
		xrandr --addmode ${intern} ${modeIntern}
		echo "Se ha creado en xrandr el modo ${modeIntern} para ${intern}"

fi
modeExtern="--mode ${modeExtern}"
modeIntern="--mode ${modeIntern}"

#
# Gestion de opciones pasadas al script para establecer pantallas encendidas o apagadas.
#
if [ "$attrOne" == "-o" ] #Validamos que la opcion pasada es la de escojer solo una de las pantallas (-o: only).
then
	if [ "$attrSec" == 'l' ] #chequeamos que la opcion pasada sea la pantalla Izquierda (l: left).
	then
		echo "Invocada la orden de Mantener activa solo la pantalla Izquierda."
		xrandr --output ${intern} ${posExtern} --rotate normal
                xrandr --output ${extern} --primary ${modeExtern} ${posExtern} --rotate normal --output ${intern} --off --output VIRTUAL1 --off

	elif [ "$attrSec" == 'r' ] #chequeamos que el monitor escogido sea el Izquierdo.
	then
		echo "Invocada la orden de Mantener activa solo la pantalla Derecha (Laptop)."

		xrandr --output ${extern} --rotate normal
                xrandr --output ${intern} --primary ${modeIntern} ${posIntern} --rotate normal --output ${extern} --off --output VIRTUAL1 --off

	else
		#Si no se escribe el segundo parametro asumimos que se desea activar por defecto ambas pantallas.
		echo "Invocada orden por defecto de mantener encendida ambas pantallas."
                xrandr --output ${intern} ${modeIntern} ${posIntern} --rotate normal --output ${extern} --primary ${modeExtern} ${posExtern} --rotate normal --auto --output VIRTUAL1 --off
	fi

elif [ "$attrOne" == '-p' ] #Validamos que la opcion introducida sea la de encender una de las pantallas apagadas (-p: power)
then
	if [ "$attrSec" == 'l' ] #chequeamos que se este procurando encender la pantalla izquierda. 
	then
		echo "Emitida orden de encender (-p: power) la pantalla Izquierda"
                xrandr --output ${intern} ${modeIntern} ${posIntern} --rotate normal --output ${extern} --primary ${modeExtern} ${posExtern} --rotate normal --auto --output VIRTUAL1 --off
		
	elif [ "$attrSec" == 'r' ] #chequeamos que se este procurando encender la pantalla derecha.
	then
		echo "Emitida la orden de encender la pantalla Derecha."
                xrandr --output ${extern} ${modeExtern} ${posExtern} --rotate normal --output ${intern} --primary ${modeIntern} ${posIntern} --rotate normal --auto --output VIRTUAL1 --off

	else
		#En el caso de que se invoque la opcion de encender una pantalla pero no se especifique si es la derecha o la izquierda se asumira que se trata de un error. se recomienda al usuario volver a intentar el procedimiento sin errores.
		echo "Opcion invalida, vuelva a repetir la instruccion asegurandose que usa '-l (left)' o '-r (right)'."
	fi
else
		#Si no se escribe opcion alguna al correr el script entonces se asume que se desea por defecto ambos monitores encendidos
                echo "Invocada orden por defecto de mantener encendida ambas pantallas."
                xrandr --output ${intern} ${modeIntern} ${posIntern} --rotate normal --output ${extern} --primary ${modeExtern} ${posExtern} --rotate normal --auto --output VIRTUAL1 --off

fi


#
# Apagando monitor desconectado;
#
if xrandr | grep "${extern} disconnected"
	then

                xrandr --output ${intern} --primary ${modeIntern} ${posIntern} --rotate normal --output ${extern} --off --output VIRTUAL1 --off
		echo "Apagando el monitor ${extern}"
fi
