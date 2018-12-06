#install.packages('plyr')
#install.packages('dplyr')
library('plyr')
library('dplyr')

# le arquivos
arq_amazon_echo <- read.csv("/home/ubuntu/Documentos/TP3/joy/flows-volume-amazon-echo.txt", header=FALSE)
arq_LIFX_lighbulb <- read.csv("/home/ubuntu/Documentos/TP3/joy/flows-volume-LIFX-lighbulb.txt", header=FALSE)
arq_belkin_motion <- read.csv("/home/ubuntu/Documentos/TP3/joy/flows-volume-belkin-motion.txt", header=FALSE)

arq_sleep_sensor <- read.csv("/home/ubuntu/Documentos/TP3/joy/flows-volume-sleep-sensor.txt", header=FALSE)
arq_blipcareBP <- read.csv("/home/ubuntu/Documentos/TP3/joy/flows-volume-blipcare-BP.txt", header=FALSE)

# calcula a função da probabilidades seguindo a distribuição normal (contínua)
fp_amazon <- dnorm(arq_amazon_echo$V1,mean(arq_amazon_echo$V1),sd(arq_amazon_echo$V1))
fp_LIFX  <- dnorm(arq_LIFX_lighbulb$V1,mean(arq_LIFX_lighbulb$V1),sd(arq_LIFX_lighbulb$V1))
fp_belkin <- dnorm(arq_belkin_motion$V1,mean(arq_belkin_motion$V1),sd(arq_belkin_motion$V1))

fp_sleep <- dnorm(arq_sleep_sensor$V1,mean(arq_sleep_sensor$V1),sd(arq_sleep_sensor$V1))
fp_blipcareBP <- dnorm(arq_blipcareBP$V1,mean(arq_blipcareBP$V1),sd(arq_blipcareBP$V1))


# plots individuais
plot(arq_amazon_echo$V1, fp_amazon, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='blue',xlim=c(0,4000),
     main = "Amazon Echo")
plot(arq_belkin_motion$V1, fp_belkin, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='green', xlim=c(0,4000),
     main = "Belkin Motion")
plot(arq_LIFX_lighbulb$V1, fp_LIFX, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='red',xlim=c(0,4000),
     main = "LIFX_lighbulb")
plot(arq_sleep_sensor$V1, fp_sleep, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='magenta',xlim=c(0,4000),
     main = "Sleep Sensor")
plot(arq_blipcareBP$V1, fp_blipcareBP, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='yellow',xlim=c(0,4000),
     main = "Blipcare Blood Pressure")


# plot junto
par(mar=c(5.1,5,4.1,2.1))
ymax = max(fp_belkin, fp_amazon, fp_LIFX, fp_sleep)
plot(arq_amazon_echo$V1, fp_amazon, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='blue', xlim=c(0,4000),
     ylim=c(0,ymax),cex.axis=1.5, cex.lab=1.6)
abline(h=c(0.000,0.001,0.002,0.003,0.004), col="lightgray")
abline(v=c(0,1000,2000,3000,4000), col="lightgray")
lines(arq_belkin_motion$V1, fp_belkin, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='green', xlim=c(0,4000), ylim=c(0,ymax))
lines(arq_LIFX_lighbulb$V1, fp_LIFX, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='red', xlim=c(0,4000), ylim=c(0,ymax))
lines(arq_sleep_sensor$V1, fp_sleep, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='magenta', xlim=c(0,4000), ylim=c(0,ymax))

colors <- c("blue", "green", "red", "magenta")
labels <- c("Amazon Echo", "Belkin Motion","LiFX lighbulb", "Sleep Sensor")
legend("topright",labels, border = "black", fill = colors, cex = 1.8)

# plot apenas de Amazon Echo e Belkin Motion

par(mar=c(5.1,5,4.1,2.1))
ymax = max(fp_belkin, fp_amazon)
plot(arq_amazon_echo$V1, fp_amazon, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='blue', xlim=c(0,4000),
     ylim=c(0,ymax), cex.axis=1.4, cex.lab=1.6)
lines(arq_belkin_motion$V1, fp_belkin, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='green', xlim=c(0,4000), 
      ylim=c(0,ymax))
lines(arq_sleep_sensor$V1, fp_sleep, type="h", xlab="X: flow volume (Bytes)", ylab="Probability: P(flow volume = x)", col='magenta', xlim=c(0,4000), ylim=c(0,ymax))
colors <- c("blue", "green", "magenta")
labels <- c( "Amazon Echo", "Belkin Motion","Sleep Sensor")
legend("topright",labels, border = "black", fill = colors, cex = 1.8)



