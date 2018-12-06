# Trabalho Prático 3 - TP3
 
## Análise do Tráfego de Dados de Dispositivos IoT

Neste trabalho analisamos o tráfego de diferentes dispositivos IoT, incluindo sensores, monitores da qualidade do AR e câmeras, a fim de auxiliar na caracterização do tráfego e na identificação de atividades padrões. Por meio da caracterização e identificação do tráfego da rede é possível oferecer serviços de QoS, como prioridade de transmissão no meio de acesso, e serviços de segurança para dispositivos que possuem maiores requisitos de privacidade. Neste sentido, nesse TP3 nós realizamos uma Análise do Tráfego de Dados de Dispositivos IoT, chamado XXX, com base no artigo *"Classifying IoT Devices in Smart Environments Using Network Traffic Characteristics"*, que também realiza uma caracterização de tráfego. O XXX emprega um dados de tráfego de rede e utiliza diferentes ferramentas, como thsark e R, para realizar as análises.


## Reproduzindo nossas análises

### Pré-requisitos

Antes de tudo, nós realizamos nossas análises no Ubuntu 16.04 LTS.

**1)** Primeiramente é necessário fazer o download dos dados de tráfego da rede. O comando abaixo faz o download de um arquivo pcap específico, caso você quiser algum outro pcap acesse o [site](https://iotanalytics.unsw.edu.au/iottraces.html). 

```
wget https://iotanalytics.unsw.edu.au/iottestbed/pcap/16-10-12.pcap --no-check-certificate
wget https://iotanalytics.unsw.edu.au/resources/List_Of_Devices.txt --no-check-certificate
```

Salve os pcaps que você baixar dentro do diretório ```TP3/pcaps/```. Devido ao limite de dados do GitHub, não conseguimos disponibilizar os arquivos pcaps.

**2)** Instalar, configurar as ferramentas necessárias (Tshark, Tcpdump, Joy e dependências) 

```
sudo apt-get install build-essential libssl-dev libpcap-dev libcurl4-openssl-dev
sudo apt-get install tshark tcpdump
sudo apt-get update
git clone https://github.com/cisco/joy.git
cd joy
[joy]$ ./configure --enable-gzip
[joy]$ make clean
[joy]$ make
sudo apt-get update; apt-get install gcc git libcurl3 libcurl4-openssl-dev libpcap0.8 libpcap-dev libssl1.0.0 libssl-dev make python python-pip ruby ruby-ffi
./build_pkg -t deb

```

**3)** Instalar R e R-Studio e suas dependências também, [site R](https://cloud.r-project.org/bin/linux/ubuntu/README.html) ..

### Reproduzindo ..

**4)** Para realizar a manipulação do tráfego dos dispositivos que usamos (Amazon Echo, Belkin Motion, LIFX lighbulb), execute:

```
./run_analysis.sh
``` 

Explicação do script:

No script ```run_analysis.sh``` nós realizamos toda a manipulação dos arquivos. Primeiro, separamos os pcaps conforme o dispositivo IoT que gerou o tráfego (o endereço MAC foi utilizado para fazer essa separação):

Exemplo:
```
fileOutDisp="16-10-11-belkin-motion.pcap"
echo "Criando pcap apenas com tráfego do dispositivo Belkin Motion"
tshark -Y "eth.src==ec:1a:59:83:28:11" -r 16-10-11.pcap -w ${fileOutDisp}

```
O arquivo ```List_Of_Devices.txt``` detalha o endereço MAC de cada um dos dispositivos.
  
Após separar o tráfego de cada dispositivo IoT, precisamos criar os arquivos JSON com as informações do tráfego para cada dispositivo. Para isso, utilizamos a ferramenta Joy da Cisco:

```
cd TP3/joy/
bin/joy verbosity=1 output=amazon-echo.json ../TP3/pcaps/16-10-11-amazon-echo.pcap
bin/joy verbosity=1 output=belkin-motion.json ../TP3/pcaps/16-10-11-belkin-motion.pcap
bin/joy verbosity=1 output=LIFX-lighbulb.json ../TP3/pcaps/16-10-11-LIFX-lighbulb.pcap
```

Então, executamos o **sleuth** para extrair as features desejadas. Ele permite selecionar os fluxos conforme as 5-tuples (endereço IP de destino, porta de destino, endereço IP de origem, porta de origem e protocolo). A Cisco desenvolveu isso para facilitar a análise de tráfego. Para capturarmos o volume de fluxo de cada dispositivo é necessário somar a quantidade de bytes de cada fluxo. Para isso, fizemos o seguinte:

```
./sleuth amazon-echo.json --select "sa,sp,da,dp,pr,bytes_out" --groupby sa,sp,da,dp,pr --sum bytes_out | sort -k 2 -nr > flows-amazon-echo.txt
./sleuth LIFX-lighbulb.json --select "sa,sp,da,dp,pr,bytes_out" --groupby sa,sp,da,dp,pr --sum bytes_out | sort -k 2 -nr > flows-LIFX-lighbulb.txt
./sleuth belkin-motion.json --select "sa,sp,da,dp,pr,bytes_out" --groupby sa,sp,da,dp,pr --sum bytes_out | sort -k 2 -nr > flows-belkin-motion.txt
```

E por fim, extraímos a soma dos bytes e armazenamos em outro arquivo de saída (para cada dispositivo):

```
awk '{print $4}' flows-amazon-echo.txt  > flows-volume-amazon-echo.txt 
awk '{print $4}' flows-LIFX-lighbulb.txt  > flows-volume-LIFX-lighbulb.txt 
awk '{print $4}' flows-belkin-motion.txt  > flows-volume-belkin-motion.txt 
```

**5)** Agora que extraímos as características desejadas, vamos utilizar o R para calcular a função da distribuição da probabilidade e gerar os gráficos. Para isso, sugerimos abrir o script ```probability_distribution.R``` no R-Studio e executar os comandos linha por linha, a fim de salvar todos os gráficos gerados. Pois, caso você executar pela terminal bash, usando o comando ```Rscript probability_distribution.R```, você só terá o resultado do último gráfico. Após executar o script no R, você terá os gráficos do volume de fluxo *vs* a distribuição da probabilidade.

Divirta-se (;


