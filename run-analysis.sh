#!/bin/bash

cd /home/ubuntu/Documentos/TP3/pcaps/


echo "-----------Extraindo Pcaps - Start --------------"

# Device >> Amazon Echo
fileOutDisp="16-10-11-amazon-echo.pcap"
echo "Criando pcap apenas com tráfego do dispositivo Amazon Echo"
tshark -Y "eth.src==44:65:0d:56:cc:d3" -r 16-10-11.pcap -w ${fileOutDisp}


# Device >> Belkin Motion
fileOutDisp="16-10-11-belkin-motion.pcap"
echo "Criando pcap apenas com tráfego do dispositivo Belkin Motion"
tshark -Y "eth.src==ec:1a:59:83:28:11" -r 16-10-11.pcap -w ${fileOutDisp}


# Device >> LIFX lighbulb
fileOutDisp="16-10-11-LIFX-lighbulb.pcap"
echo "Criando pcap apenas com tráfego do dispositivo LIFX lighbulb (Light Bulbs LiFX Smart Bulb)"
tshark -Y "eth.src==d0:73:d5:01:83:08" -r 16-10-11.pcap -w ${fileOutDisp}


# Device >> Withings Aura smart sleep sensor
fileOutDisp="16-10-11-sleep-sensor.pcap"
echo "Criando pcap apenas com tráfego do dispositivo Withings Aura smart sleep sensor"
tshark -Y "eth.src==00:24:e4:20:28:c6" -r 16-10-11.pcap -w ${fileOutDisp}


# Device >> Blipcare Blood Pressure meter
fileOutDisp="16-10-12-blipcare-BP.pcap"
echo "Criando pcap apenas com tráfego do dispositivo Blipcare Blood Pressure meter"
tshark -Y "eth.src==74:6a:89:00:2e:25" -r 16-10-12.pcap -w ${fileOutDisp}
	
echo "-----------Preparação dos Pcaps - Finished --------------"



#ExecutaJoy

cd /home/ubuntu/Documentos/TP3/joy/

echo "-----------Extraindo features com Joy - Start --------------"

echo "->>>> Criando os arquivos JSON para cada dispositivo ... "
bin/joy verbosity=1 output=amazon-echo.json ../pcaps/16-10-11-amazon-echo.pcap
bin/joy verbosity=1 output=belkin-motion.json ../pcaps/16-10-11-belkin-motion.pcap
bin/joy verbosity=1 output=LIFX-lighbulb.json ../pcaps/16-10-11-LIFX-lighbulb.pcap

bin/joy verbosity=1 output=sleep-sensor.json ../pcaps/16-10-11-sleep-sensor.pcap
bin/joy verbosity=1 output=blipcare-BP.json ../pcaps/16-10-12-blipcare-BP.pcap
echo "Arquivos gerados: 16-10-11-amazon-echo.pcap | 16-10-11-belkin-motion.pcap | 16-10-11-LIFX-lighbulb.pcap "	

echo "->>>> Aplicando Sleuth para extrair as features desejadas ... "
./sleuth amazon-echo.json --select "sa,sp,da,dp,pr,bytes_out" --groupby sa,sp,da,dp,pr --sum bytes_out | sort -k 2 -nr > flows-amazon-echo.txt
./sleuth LIFX-lighbulb.json --select "sa,sp,da,dp,pr,bytes_out" --groupby sa,sp,da,dp,pr --sum bytes_out | sort -k 2 -nr > flows-LIFX-lighbulb.txt
./sleuth belkin-motion.json --select "sa,sp,da,dp,pr,bytes_out" --groupby sa,sp,da,dp,pr --sum bytes_out | sort -k 2 -nr > flows-belkin-motion.txt

./sleuth sleep-sensor.json --select "sa,sp,da,dp,pr,bytes_out" --groupby sa,sp,da,dp,pr --sum bytes_out | sort -k 2 -nr > flows-sleep-sensor.txt
./sleuth blipcare-BP.json --select "sa,sp,da,dp,pr,bytes_out" --groupby sa,sp,da,dp,pr --sum bytes_out | sort -k 2 -nr > flows-blipcare-BP.txt
echo "Arquivos gerados: flows-amazon-echo.txt | flows-LIFX-lighbulb.txt | flows-belkin-motion.txt "

echo "->>>> Extraindo volume do fluxo dos arquivos gerados pelo Sleuth ..."
awk '{print $4}' flows-amazon-echo.txt  > flows-volume-amazon-echo.txt 
awk '{print $4}' flows-LIFX-lighbulb.txt  > flows-volume-LIFX-lighbulb.txt 
awk '{print $4}' flows-belkin-motion.txt  > flows-volume-belkin-motion.txt 

awk '{print $4}' flows-sleep-sensor.txt  > flows-volume-sleep-sensor.txt 
awk '{print $4}' flows-blipcare-BP.txt  > flows-volume-blipcare-BP.txt 
echo "Arquivos gerados: flows-volume-amazon-echo.txt | flows-volume-LIFX-lighbulb.txt | flows-volume-belkin-motion.txt "

echo "-----------Extração das Features - Finished --------------"





