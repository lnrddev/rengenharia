library(openxlsx)
library(deSolve)

# Função de velocidade de reação em série

rxnrate <- function(t,c,parms){
  # constantes de velocidade são passadas como parâmetros da função
  k1    <- parms$k1
  k2    <- parms$k2
  # C representa a concentração de cada reagente, A, B e C.
  # Entre abaixo com as derivadas
  r     <- rep(0,length(c))
  r[1]  <- -k1*c["A"] #dcA/dt
  r[2]  <- k1*c["A"]-k2*c["B"] #dcB/dt
  r[3]  <- k2*c["B"] #dcC/dt
  # As derivadas são retornadas como uma listas.
  # A ordem das derivadas necessitam ser a mesma ordem em C.
  
  return(list(r))
}

cinit <- c(A=1,B=0,C=0) # Concentrações em t igual a zero
t     <- seq(from =0, to = 5, by = 0.1) # Cria intervalo de tempo
parms <- list(k1=2,k2=1) # Qual o valor de k1 e k2?
out  <- ode(y=cinit,times=t,func=rxnrate,parms=parms) # Resolve o sistemas de ODE e atribui à saída out
head(out) # Mostra apenas as primeiras linhas dos dados... 

plot(out)
dev.off()

out   <- as.data.frame(out)

plot(out$time, out$A, type = "l")
lines(out$time, out$B)
lines(out$time, out$C)


#####################################
# Ajustando aos dados experimentais #
#####################################

# Leitura dos dados

df <- read.xlsx("dados_rk4.xlsx", colNames = FALSE)
names(df) <- c("tempo", "ca", "cb", "cc")

# Função de minimização do erro de ajuste

library(reshape2)

ssq <- function(parms){
  # Concentrações iniciais
  cinit <- c(A=1,B=0,C=0)
  # Mesclando o tempo de 0 a 5, de 0.1 a 0.1 com os tempos experimentais
  t <- c(seq(0,5,0.1),df$tempo)
  t <- sort(unique(t))
  # Parâmetros do modelo
  k1 <- parms[1]
  k2 <- parms[2]
  # Resolvendo a EDO
  out <- ode(y=cinit,times=t,func=rxnrate,parms=list(k1=k1,k2=k2))
  # Filtra os dados que estão par a par em ambos dataframes
  outdf <- data.frame(out)
  outdf <- outdf[outdf$time %in% df$tempo,]
  # Calcula o resíduo, experimental menos o ajuste
  preddf <- melt(outdf,id.var="time",variable.name="Espécies",value.name="conc")
  expdf <- melt(df,id.var="tempo",variable.name="Espécies",value.name="conc")
  ssqres <- preddf$conc-expdf$conc
  # Retorna o resíduo
  return(ssqres)
}

# Ajustando usando Levenberg-Marquardt
library(minpack.lm)

# Estimativa inicial dos parâmetros cinéticos.

parms <- c(k1=3,k2=1)
# Ajuste
fitval  <- nls.lm(par=parms,fn=ssq)
# Resumo
summary(fitval)



library(ggplot2)


parest <- as.list(coef(fitval))


# plot of predicted vs experimental data
# simulated predicted profile at estimated parameter values
cinit <- c(A=1,B=0,C=0)
t <- seq(0,5,0.1)
parms <- as.list(parest)
out <- ode(y=cinit,times=t,func=rxnrate,parms=parms)
outdf <- data.frame(out)
names(outdf) <- c("time","ca_pred","cb_pred","cc_pred")
# Overlay predicted profile with experimental data
tmppred <- melt(outdf,id.var=c("time"),variable.name="species",value.name="conc")
tmpexp <- melt(df,id.var=c("tempo"),variable.name="species",value.name="conc")
p <- ggplot(data=tmppred,aes(x=time,y=conc,color=species,linetype=species))+geom_line()
p <- p+geom_line(data=tmpexp,aes(x=tempo,y=conc,color=species,linetype=species))
p <- p+geom_point(data=tmpexp,aes(x=tempo,y=conc,color=species))
p <- p+scale_linetype_manual(values=c(0,1,0,1,0,1))
p <- p+scale_color_manual(values=rep(c("red","blue","green"),each=2))+theme_bw()
print(p)

ggsave(file = "grafico.png", p,
       width = 13, height = 10, units = c("cm"))
