####---------------------------------Sección 1. Librerías --------------------------------####  
#### 1.1. Instalación y/o actualización ####
      
install.packages("dplyr")
install.packages("readxl")
install.packages("readr")
install.packages("graphics")
install.packages("ggplot2")
install.packages("patchwork")
install.packages("tidyr")

#### 1.2 Librerías necesarias ####

library(dplyr)
library(readxl)
library(readr)
library(graphics)
library(ggplot2)
library(patchwork)
library(tidyr)



######-------------------- Sección 2. Inicialización de la Base de datos ------------------#####

#Se guardó la base de datos .csv a la variable base. 
base <- read_csv("numMexu.csv")
View(base)

#Cambio de nombres a las columnas
names(base)[names(base)=="Familia actualizada"]<-"fam"
names(base)[names(base)=="Género actualizado"]<-"gen"
names(base)[names(base)=="Especie actualizada"]<-"esp"
names(base)[names(base)=="Taxa infraespecífico"]<-"taxa"
names(base)[names(base)=="Autor"]<-"autor"
names(base)[names(base)=="MEXUw"]<-"mexuw" 
names(base)[names(base)=="Colector"]<-"col"
names(base)[names(base)=="Colectores asociados"]<-"col2"
names(base)[names(base)=="N° Colecta"]<-"no" 
names(base)[names(base)=="Familia anterior"]<-"fam2"
names(base)[names(base)=="Género anterior"]<-"gen2"
names(base)[names(base)=="Especie anterior"]<-"esp2"
names(base)[names(base)=="Estado"]<-"est"
names(base)[names(base)=="País"]<-"pais"
names(base)[names(base)=="Fecha"]<-"fecha"
names(base)[names(base)=="Día"]<-"d"
names(base)[names(base)=="Mes"]<-"m"
names(base)[names(base)=="Año"]<-"a"
names(base)[names(base)=="Institución"]<-"inst"
names(base)[names(base)=="Donaciones"]<-"dona"
names(base)[names(base)=="Péstamos/ Exhibiciones"]<-"presx"
names(base)[names(base)=="Nombre común"]<-"nomCom"
names(base)[names(base)=="Forma de vida"]<-"forma"
names(base)[names(base)=="Parte del árbol donde se realizó la colecta"]<-"part"
names(base)[names(base)=="Altura"]<-"alt"
names(base)[names(base)=="DAP"]<-"dap"
names(base)[names(base)=="Altura de colecta"]<-"altCol"
names(base)[names(base)=="N° Fam"]<-"noFam"
names(base)[names(base)=="Nº Género"]<-"noGen"


View(base)


#Se dan los datos iniciales de los registros de México
cat("El número de registros de maderas de México es: ", sum(base$pais == "México", na.rm = TRUE))
cat("Hay ", sum(base$pais == "México", na.rm = TRUE), " registros de maderas en MX")




#####----------------------------- Sección 3. Registros nacionales --------------------------####

# Filtro de la base original, los datos de México
dataMexico <- subset(base, pais == "México")

# Uno las columnas 'gen' y 'esp' en una nueva columna 'gen_esp'.
dataMexico <- dataMexico %>%
   unite("gen_esp", gen, esp, sep = " ")

# Frecuencia de los Generos especies en México..
frecGenEspX <- table(dataMexico$gen_esp)
frecGenEspX <- data.frame(frecGenEspMX)

names(frecGenEspX) <- c("Género especie", "Frecuencia")

frecGenEspX <- frecGenEspX[order(frecGenEspX$Frecuencia, decreasing = TRUE), ] 
rownames(frecGenEspX) <- NULL


#DATOS DE NÚMEROS DE COLECTAS POR PAÍS
regPais <- as.data.frame(table(base$pais))
colnames(regPais) <- c("País", "Frecuencia")


# Distribución de registros únicos por Estado.
genEspPorEstado <- dataMexico%>%
   filter(!is.na(est)) %>%  # Excluir NA
   group_by(est) %>%
   summarise(frecuencia = n_distinct(gen_esp)) %>%
   arrange(desc(frecuencia)) 

ggplot(genEspPorEstado, aes(x = reorder(est, frecuencia), y = frecuencia)) +
   geom_bar(stat = "identity", fill = "skyblue") +
   coord_flip() +  # Rotar el gráfico para etiquetas largas
   labs(title = "Distribución de Especies por Estado en México",
        x = "Estado",
        y = "Número de Especies") +
   theme_minimal() +
   theme(axis.text.y = element_text(size = 9))


#####--------------------------- Sección 3.1 Distribución estatal -----------------------####

#Filtros de los Estados con mayores registros.
frecGenEspVera <- dataMexico %>% 
   filter(est == "Veracruz") %>% 
   group_by(gen_esp) %>%
   summarise(frecuencia = n()) %>%
   arrange(desc(frecuencia)) %>%
   slice_head(n = 10)

frecGenEspJal <- dataMexico %>% 
   filter(est == "Jalisco") %>%
   group_by(gen_esp) %>%
   summarise(frecuencia = n()) %>%
   arrange(desc(frecuencia)) %>%
   slice_head(n = 10)

frecGenEspCam <- dataMexico %>% 
   filter(est == "Campeche")%>%
   group_by(gen_esp) %>%
   summarise(frecuencia = n()) %>%
   arrange(desc(frecuencia)) %>%
   slice_head(n = 10)

frecGenEspChiap<- dataMexico %>% 
   filter(est == "Chiapas") %>%
   group_by(gen_esp) %>%
   summarise(frecuencia = n()) %>%
   arrange(desc(frecuencia))  %>%
   slice_head(n = 10)

frecGenEspMich <-  dataMexico %>% 
   filter(est == "Michoacán") %>%
   group_by(gen_esp) %>%
   summarise(frecuencia = n()) %>%
   arrange(desc(frecuencia))  %>%
   slice_head(n = 10)


#Gráficas de registros de especies.
ggplot(frecGenEspVera, aes(x = reorder(gen_esp, frecuencia), y = frecuencia)) +
   geom_bar(stat = "identity", fill = "skyblue") +  # Usar fill para colorear las barras
   coord_flip() +  # Rotar el gráfico para mejorar la legibilidad de las etiquetas
   labs(title = paste("Especies de Veracruz"),
        x = "Especie",
        y = "Frecuencia") +
   theme_minimal() +
   theme(axis.text.y = element_text(size = 10, face = "italic"))


ggplot(frecGenEspJal, aes(x = reorder(gen_esp, frecuencia), y = frecuencia)) +
   geom_bar(stat = "identity", fill = "orange") +  # Usar fill para colorear las barras
   coord_flip() +  # Rotar el gráfico para mejorar la legibilidad de las etiquetas
   labs(title = paste("Especies de Jalisco"),
        x = "Especie",
        y = "Frecuencia") +
   theme_minimal() +
   theme(axis.text.y = element_text(size = 10, face = "italic"))


ggplot(frecGenEspCam, aes(x = reorder(gen_esp, frecuencia), y = frecuencia)) +
   geom_bar(stat = "identity", fill = "pink") +  # Usar fill para colorear las barras
   coord_flip() +  # Rotar el gráfico para mejorar la legibilidad de las etiquetas
   labs(title = paste("Especies de Campeche"),
        x = "Especie",
        y = "Frecuencia") +
   theme_minimal() +
   theme(axis.text.y = element_text(size = 10, face = "italic")) #HABLAR DE ESTEBAN MARTÍNEZ


ggplot(frecGenEspChiap, aes(x = reorder(gen_esp, frecuencia), y = frecuencia)) +
   geom_bar(stat = "identity", fill = "pink") +  # Usar fill para colorear las barras
   coord_flip() +  # Rotar el gráfico para mejorar la legibilidad de las etiquetas
   labs(title = paste("Especies de Chiapas"),
        x = "Especie",
        y = "Frecuencia") +
   theme_minimal() +
   theme(axis.text.y = element_text(size = 10), face = "italic") #colección antiguas


ggplot(frecGenEspMich, aes(x = reorder(gen_esp, frecuencia), y = frecuencia)) +
   geom_bar(stat = "identity", fill = "purple") +  # Usar fill para colorear las barras
   coord_flip() +  # Rotar el gráfico para mejorar la legibilidad de las etiquetas
   labs(title = paste("Especies de Michoacán"),
        x = "Especie",
        y = "Frecuencia") +
   theme_minimal() +
   theme(axis.text.y = element_text(size = 10), face = "italic")




#####--------------------------- Sección 3.2 Formas de vida -----------------------####

dataFormaVidaMX <- table(dataMexico$forma)
frecFormaVidMX <- data.frame(dataFormaVidaMX)

names(frecFormaVidMX) <- c("Forma", "Frecuencia") #Le asigno esos nombres a las columnas

frecFormaVidMX <- frecFormaVidMX[order(frecFormaVidMX$Frecuencia, decreasing = TRUE), ]
rownames(frecFormaVidMX) <- NULL


ggplot(frecFormaVidMX, aes(x = reorder(Forma, Frecuencia), y = Frecuencia)) +
   geom_bar(stat = "identity", fill = "skyblue") +  
   coord_flip() +  
   labs(title = paste("Formas de vida en México"),
        x = "Tipo de vida",
        y = "Frecuencia") +
   theme_minimal() +
   theme(axis.text.y = element_text(size = 10))


# Crear la gráfica sin incluir "Árbol"
ggplot(frecFVSinArb, aes(x = reorder(Forma, Frecuencia), y = Frecuencia)) +
   geom_bar(stat = "identity", fill = "skyblue") +  
   coord_flip() +  
   labs(title = paste("Formas de vida en México (sin Árboles)"),
        x = "Tipo de vida",
        y = "Frecuencia") +
   theme_minimal() +
   theme(axis.text.y = element_text(size = 10))

#####--------------------------- Sección 3.3 Datos por años -----------------------####

#20 AÑOS CON MAYORES REGISTROS
regAnio <- as.data.frame(table(base$a))  
colnames(regAnio) <- c("Año", "Frecuencia") 
regAnio$Año <- as.numeric(as.character(regAnio$Año)) # Convertir 'Año' a numérico

top20Anios <- regAnio %>%
   arrange(desc(Frecuencia)) %>%  
   slice(1:20)                    

ggplot(top20Anios, aes(x = reorder(Año, -Frecuencia), y = Frecuencia)) +  
   geom_bar(stat = "identity", fill = "#96CFBE") +  
   theme_minimal() +                                 
   labs(title = "Años con Mayor Número de Registros.", 
        x = "Año",                                              
        y = "Cantidad de Registros") +                         
   theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) + 
   coord_flip() 


#LINEA DEL TIEMPO
# Filtrar para quitar el año 10
regAnio <- regAnio %>%
   filter(Año > 1920)

# Crear el gráfico de línea continua sin el año 10
ggplot(regAnio, aes(x = Año, y = Frecuencia)) +
   geom_line(color = "#96CFBE", size = 1) +  # Línea continua que conecta los puntos de cada año
   geom_point(color = "#96CFBE", size = 3) +  # Puntos en cada año para mayor claridad
   theme_minimal() +                                
   labs(title = "Número de Registros por Año", 
        x = "Año",                                              
        y = "Cantidad de Registros") +                         
   theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
   



#####--------------------------- Sección 3.4 Datos de instituciones -----------------------####

base <- base %>%
   mutate(inst = ifelse(inst == "Fiel Museum of Natural History", "Field Museum of Natural History", inst))


base_filtrada <- base %>%
   filter(inst != "Missouri Botanical Garden")

# Crea la tabla de frecuencia
regInsti <- as.data.frame(table(base_filtrada$inst))
colnames(regInsti) <- c("Institución", "Frecuencia")

# Selecciona las 15 instituciones con mayores registros
topInstituciones <- regInsti %>%
   arrange(desc(Frecuencia)) %>%
   slice(1:15)

# Grafica los datos
ggplot(topInstituciones, aes(x = reorder(Institución, -Frecuencia), y = Frecuencia)) + 
   geom_bar(stat = "identity", fill = "#722f37") +  
   theme_minimal() +
   labs(title = "Instituciones con Mayores Registros",
        x = "Institución", 
        y = "Cantidad de Registros") +
   theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
   coord_flip()


regInstSinIB <- base %>% filter(inst != "Instituto de Biología, UNAM", )


regInstSinIB <- as.data.frame(table(regInstSinIB$inst))
colnames(regInstSinIB) <- c("Instituciones", "Frecuencia")

regInstSinIB <- regInstSinIB %>%
   arrange(desc(Frecuencia)) %>%
   slice(1:15)

ggplot(regInstSinIB, aes(x = reorder(Instituciones, -Frecuencia), y = Frecuencia)) + 
   geom_bar(stat = "identity", fill = "#722f37") +  # Color morado pastel
   theme_minimal() +
   labs(title = "Instituciones (excluyendo IB)",
        x = "Institución", 
        y = "Cantidad de Registros") +
   theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
   coord_flip() 




#####----------------------------- Sección 4. Registros internacionales --------------------------#####

topPaises <- regPais %>%
   arrange(desc(Frecuencia)) %>%
   slice(1:20)

ggplot(topPaises, aes(x = reorder(País, -Frecuencia), y = Frecuencia)) + 
   geom_bar(stat = "identity", fill = "#172BDE") + 
   theme_minimal() +
   labs(title = "Registros por País",
        x = "País", 
        y = "Cantidad de Registros") +
   theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
   coord_flip()

# DATOS DE AÑOS DE COLECTAS FUERA DE MÉXICO
regFuera <- base %>% filter(pais != "México", a > 1920)

regAnioFuera <- as.data.frame(table(regFuera$a))
colnames(regAnioFuera) <- c("Año", "Frecuencia")

topRegAnioFuera <- regAnioFuera %>%
   arrange(desc(Frecuencia)) %>%
   slice(1:20)  


ggplot(topRegAnioFuera, aes(x = reorder(Año, -Frecuencia), y = Frecuencia)) + 
   geom_bar(stat = "identity", fill = "#96CFBE") +  
   theme_minimal() +
   labs(title = "Años con Más Registros (Extranjero)",
        x = "Año", 
        y = "Cantidad de Registros") +
   theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
   coord_flip()

