#On ouvre les données
data = read.csv2('data.csv', dec=".")

#Sert à calculer la moyenne et l'écart type d'une variable par groupe
data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      sd = sd(x[[col]], na.rm=TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
 return(data_sum)
}

## --------Impact de RO-------- ##
# (Temps de simu fixe)
ro_data = subset(data, data$time == 1000000)
ro_data <- transform(ro_data, ro=lambda/mu)
ro_data <- transform(ro_data, client_wait=1-client_no_wait)
ro_data <- transform(ro_data, debit=nb_clients/time)

# Clients en attente/RO     
client_attente_df = data_summary(
  ro_data, 
  varname="client_wait", 
  groupnames=c("ro")
)

plot(
  main="Proporiton des clients ayant attendu en fonction de RO \n(temps fixé à 1000000)",
  xlab="RO (lambda/mu)",
  ylab="Proportion des clients ayant attendu (%)",
  xlim=c(0.2,1), 
  ylim=c(0,1),
  x= client_attente_df$ro,
  y= client_attente_df$client_wait,
  type='o',
  col="blue"
)
points(
  x= ro_data$ro,
  y= ro_data$client_wait,
  col="red",
)
legend(
  "bottomright",
  legend=c("Moyenne", "Données"),
  col=c("blue", "red"),
  pch=c(1, 1)
)


## --------Écart à l'attendu-------- ##
# (Lambda et mu fixe)
ecart_data = subset(data, data$lambda == 5 & data$mu == 6)
ecart_data <- transform(ecart_data, nb_clients_theo=lambda*time)
ecart_data <- transform(ecart_data, clients_wait_theo=(lambda/mu))
ecart_data <- transform(ecart_data, clients_wait=1-client_no_wait)
ecart_data <- transform(ecart_data, debit_theo=lambda)
ecart_data <- transform(ecart_data, debit=nb_clients/time)
ecart_data <- transform(ecart_data, nb_moyen_clients_theo=(lambda/mu)/(1-(lambda/mu))) 
ecart_data <- transform(ecart_data, temps_sejour_theo=(1/mu)/(1-(lambda/mu)))

# Nombre total de client
nb_clients_df = data_summary(
  ecart_data, 
  varname="nb_clients", 
  groupnames=c("time")
)

plot(
  main="Nombre de clients en fonction du temps de simulation\n (Lambda = 5, Mu = 6)",
  xlab="Temps de simulation (log)",
  ylab="Nombre de clients (log)",
  log="xy",
  x= nb_clients_df$time,
  y= nb_clients_df$nb_clients,
  type='o',
  col="blue"
)
arrows(
  x0=nb_clients_df$time,
  y0=nb_clients_df$nb_clients - nb_clients_df$sd,
  x1=nb_clients_df$time,
  y1=nb_clients_df$nb_clients + nb_clients_df$sd,
  code=3, angle=90, length=0.1,
  col="blue"
  )
points(
  x= ecart_data$time,
  y= ecart_data$nb_clients_theo,
  type='o',
  col="red"
)
legend(
  "bottomright",
  legend=c("Simulation", "Attendu"),
  col=c("blue", "red"),
  pch=c(1,1)
)

# Proporiton des clients qui ont attendu
clients_wait_df = data_summary(
  ecart_data, 
  varname="clients_wait",
  groupnames=c("time")
)
plot(
  main="Proportion des clients ayant attendu\nen fonction du temps de simulation\n (Lambda = 5, Mu = 6)",
  xlab="Temps de simulation (log)",
  ylab="Proportion des clients ayant attendu (%)",
  log="x",
  ylim = c(0, max(clients_wait_df$clients_wait) + 0.1),
  x= clients_wait_df$time,
  y= clients_wait_df$clients_wait,
  type='o',
  col="blue"
)
arrows(
  x0=clients_wait_df$time,
  y0=clients_wait_df$clients_wait - clients_wait_df$sd,
  x1=clients_wait_df$time,
  y1=clients_wait_df$clients_wait + clients_wait_df$sd,
  code=3, angle=90, length=0.1,
  col="blue"
  )
points(
  x= ecart_data$time,
  y= ecart_data$clients_wait_theo,
  type='o',
  col="red"
)
legend(
  "bottomright",
  legend=c("Simulation", "Attendu"),
  col=c("blue", "red"),
  pch=c(1,1)
)

# Débit
debit_df = data_summary(
  ecart_data, 
  varname="debit",
  groupnames=c("time")
)
plot(
  main="Débit en fonction du temps de simulation\n (Lambda = 5, Mu = 6)",
  xlab="Temps de simulation (log)",
  ylab="Débit (Nombre de clients/Time)",
  log="x",
  ylim = c(min(debit_df$debit) - 2, max(debit_df$debit) + 3),
  x= debit_df$time,
  y= debit_df$debit,
  type='o',
  col="blue"
)
arrows(
  x0=debit_df$time,
  y0=debit_df$debit - debit_df$sd,
  x1=debit_df$time,
  y1=debit_df$debit + debit_df$sd,
  code=3, angle=90, length=0.1,
  col="blue"
  )
points(
  x= ecart_data$time,
  y= ecart_data$debit_theo,
  type='o',
  col="red"
)
legend(
  "bottomright",
  legend=c("Simulation", "Attendu"),
  col=c("blue", "red"),
  pch=c(1,1)
)

#Nombre moyen de clients dans le système
# Débit
nb_moyen_df = data_summary(
  ecart_data, 
  varname="nb_moyen_clients",
  groupnames=c("time")
)
plot(
  main="Nombre moyen de clients dans la file\nen fonction du temps de simulation\n (Lambda = 5, Mu = 6)",
  xlab="Temps de simulation (log)",
  ylab="Nombre moyen de clients dans la file",
  log="x",
  ylim = c(min(nb_moyen_df$nb_moyen_clients) - 2, max(nb_moyen_df$nb_moyen_clients) + 3),
  x= nb_moyen_df$time,
  y= nb_moyen_df$nb_moyen_clients,
  type='o',
  col="blue"
)
arrows(
  x0=nb_moyen_df$time,
  y0=nb_moyen_df$nb_moyen_clients - nb_moyen_df$sd,
  x1=nb_moyen_df$time,
  y1=nb_moyen_df$nb_moyen_clients + nb_moyen_df$sd,
  code=3, angle=90, length=0.1,
  col="blue"
  )
points(
  x= ecart_data$time,
  y= ecart_data$nb_moyen_clients_theo,
  type='o',
  col="red"
)
legend(
  "bottomright",
  legend=c("Simulation", "Attendu"),
  col=c("blue", "red"),
  pch=c(1,1)
)

# Temps séjour moyen
temps_sejour_df = data_summary(
  ecart_data, 
  varname="temps_sejour",
  groupnames=c("time")
)
plot(
  main="Temps de séjour moyen dans la file\nen fonction du temps de simulation\n (Lambda = 5, Mu = 6)",
  xlab="Temps de simulation (log)",
  ylab="Temps de séjour dans la file",
  log="x",
  ylim = c(min(temps_sejour_df$temps_sejour) - 2, max(temps_sejour_df$temps_sejour) + 3),
  x= temps_sejour_df$time,
  y= temps_sejour_df$temps_sejour,
  type='o',
  col="blue"
)
arrows(
  x0=temps_sejour_df$time,
  y0=temps_sejour_df$temps_sejour - temps_sejour_df$sd,
  x1=temps_sejour_df$time,
  y1=temps_sejour_df$temps_sejour + temps_sejour_df$sd,
  code=3, angle=90, length=0.1,
  col="blue"
  )
points(
  x= ecart_data$time,
  y= ecart_data$temps_sejour_theo,
  type='o',
  col="red"
)
legend(
  "bottomright",
  legend=c("Simulation", "Attendu"),
  col=c("blue", "red"),
  pch=c(1,1)
)


## --------Temps d'exécution en fonction de RO-------- ##

time_df = data_summary(
  ro_data, 
  varname="time_exec",
  groupnames=c("ro")
)

plot(
  main="Temps d'exécution en fonction de RO\n (Temps de simulation = 1000000)",
  xlab="RO (Lambda/Mu)",
  ylab="Temps d'exécution (secondes)",
  x= time_df$ro,
  y= time_df$time_exec,
  type='o',
  col="blue"
)
arrows(
  x0=time_df$ro,
  y0=time_df$time_exec - time_df$sd,
  x1=time_df$ro,
  y1=time_df$time_exec + time_df$sd,
  code=3, angle=90, length=0.1,
  col="blue"
)