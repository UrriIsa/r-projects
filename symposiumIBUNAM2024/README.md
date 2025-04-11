# Simposio IB-UNAM2024 (Symposium IB-UNAM 2024)

Este proyecto de R fue desarrollado para presentar en el Simposio de Estudiantes del Instituto de Biología de la UNAM 2024 (SiEs IBUNAM 2024), fue parte del servicio social de mi Estudio Técnico Especializado en Computación (ETEC). Se analizaron datos de una base de datos relacionada. EL objetivo del trabajo además de mostrar todo el peso histórico que tiene la Xiloteca es también recordar el arduo esfuerzo que se ha realizado por tantas personas.

***Traduction :***

This R project was developed to present at the UNAM Institute of Biology Students Symposium 2024 (SiEs IBUNAM 2024), it was part of the social service of my Estudio Técnico Especializado en Computación (ETEC). Data from a related database were analyzed. The objective of the work, besides showing all the historical weight that the Xiloteca has, is also to remember the arduous effort that has been made by so many people.

---

## Table of Contents
  
- [Características / Features](#caracteristicas--features)
- [Requisitos / Requirements](#requisitos--requirements)
- [Instalación / Installation](#instalación--installation)
- [Uso / Usage](#uso--usage)
- [Estructura del Código / Code Structure](#estructura-del-código--code-structure)
- [Licencia / License](#licencia--license)

---

## Caracteristicas / Features

- Importación y carga de datos desde un archivo CSV.
- Renombrado de columnas para facilitar el análisis.
- Análisis descriptivo de los registros nacionales con filtros.
- Visualización de frecuencias por estado, forma de vida y año.
- Utilización de paquetes como `dplyr`, `ggplot2` y `patchwork` para el análisis y graficación.

***Traduction :***

- Data import from a CSV file.
- Renaming columns to simplify analysis.
- Descriptive analysis of national records with filters.
- Visualization of frequencies by state, life form, and year.
- Use of packages like `dplyr`, `ggplot2`, and `patchwork` for analysis and plotting.

---

## Requisitos / Requirements

- [R](https://cran.r-project.org/) versión 4.0 o superior.
- [RStudio](https://posit.co/download/rstudio-desktop/) como entorno de desarrollo.
- Paquetes necesarios: `dplyr`, `readxl`, `readr`, `graphics`, `ggplot2`, `patchwork`, `tidyr`.

***Traducción:***

- [R](https://cran.r-project.org/) version 4.0 or higher.
- [RStudio](https://posit.co/download/rstudio-desktop/) as the integrated development environment.
- Required packages: `dplyr`, `readxl`, `readr`, `graphics`, `ggplot2`, `patchwork`, `tidyr`.

---

## Instalación / Installation

1. Clona este repositorio.
2. Abre el proyecto en RStudio.
3. Ejecuta el siguiente bloque de código para instalar y cargar los paquetes necesarios:

   ```r       
   install.packages("dplyr")
   install.packages("readxl")
   install.packages("readr")
   install.packages("graphics")
   install.packages("ggplot2")
   install.packages("patchwork")
   install.packages("tidyr")
   
   library(dplyr)
   library(readxl)
   library(readr)
   library(graphics)
   library(ggplot2)
   library(patchwork)
   library(tidyr)
   ```

***Traducción:***

1. Clone this repository.
2. Open the project in RStudio.
3. Execute the following code block to install and load the necessary packages:
   ```r 
   install.packages("dplyr")
   install.packages("readxl")
   install.packages("readr")
   install.packages("graphics")
   install. packages("ggplot2")
   install.packages("patchwork")
   install.packages("tidyr")
     
   library(dplyr)
   library(readxl)
   library(readr)
   library(graphics)
   library(ggplot2)
   library(patchwork)
   library(tidyr)
   ```

---

## Uso / Usage

- Coloca el archivo numMexu.csv en el mismo directorio que este script.
- Ejecuta el script en RStudio para cargar, transformar y analizar los datos.
- Visualiza las tablas y gráficas generadas en la consola y en el panel de gráficos.

***Traduction :***

- Place the file numMexu.csv in the same directory as this script.
- Run the script in RStudio to load, transform, and analyze the data.
- View the tables and plots generated in the console and the plots panel.

---

## Estructura del Código / Code Structure

El código está separado por comentarios que indican secciones de código, cada una se enfoca en cosas diferentes. ***Traduction :*** the code is separated by comments that indicate sections of code, each focusing on different things.

### Sección 1. Librerías / Section 1. Libraries)
  
  Se mencionó en el apartado de Instalación, simplemente descarga o actualiza las librerías necesarias y las carga dentro del proyecto para poder ocuparlas. ***Traduction :*** as mentioned in the Installation section, simply download or update the necessary libraries and load them into the project in order to use them.

### Sección 2. Inicialización de la Base de Datos / Section 2. Initialization of the database.

  Carga el archivo `numMexu.csv` (Base de Datos), renombra las columnas para facilitar el análisis e imprime el número de registros existentes en México. ***Traduction :*** Loads the file `numMexu.csv` (Database), renames the columns to facilitate the analysis and prints the number of existing records in Mexico.
  ```r
   ####-------------------- Sección 2. Inicialización de la Base de datos ------------------####
   
   base <- read_csv("numMexu.csv")
   View(base)
   
   names(base)[names(base)=="Familia actualizada"] <- "fam"
   names(base)[names(base)=="Género actualizado"] <- "gen"
   [...]
   names(base)[names(base)=="N° Fam"] <- "noFam"
   names(base)[names(base)=="Nº Género"] <- "noGen"

  cat("El número de registros de maderas de México es: ", sum(base$pais == "México", na.rm = TRUE))
  ```

### Sección 3. Registros Nacionales / Section 3. National Registries

  Filtra los registros para México, combina las columnas 'gen' y 'esp' en una nueva columna 'gen_esp' para tener un correcto análisis, calcula la distribución de registros únicos por estado y calcula frecuencias. ***Traduction :*** filter the records for Mexico, combine the columns 'gen' and 'esp' in a new column 'gen_esp' to have a correct analysis, calculate the distribution of unique records by state and calculate frequencies.

  #### Sección 3.1 Distribución Estatal / Section 3.1 State Distribution 

  Analiza la distribución de especies en los estados con mayor número de registros y genera gráficas. Ejemplo para Veracruz. ***Traduction :*** Analyzes the distribution of species in the states with the highest number of records and generates graphs. Example for Veracruz.
  ```r
    frecGenEspVera <- dataMexico %>%
     filter(est == "Veracruz") %>%
     group_by(gen_esp) %>%
     summarise(frecuencia = n()) %>%
     arrange(desc(frecuencia)) %>%
     slice_head(n = 10)

    ggplot(frecGenEspVera, aes(x = reorder(gen_esp, frecuencia), y = frecuencia)) +
       geom_bar(stat = "identity", fill = "skyblue") +
       coord_flip() +
       labs(title = paste("Especies de Veracruz"),
            x = "Especie",
            y = "Frecuencia") +
       theme_minimal() +
       theme(axis.text.y = element_text(size = 10, face = "italic"))
  ```

  #### Sección 3.2 Formas de Vida / Section 3.2 Life Forms
  
  Visualiza la frecuencia de las formas de vida presentes en México y las grafica. ***Traduction :*** Se toma en cuenta el Bejuco. Visualizes the frequency of life forms present in Mexico and graphs them. The Bejuco is taken into account.

  #### Sección 3.3 Datos por Años / Section 3.3 Data by Years
  
  Muestra los años con mayores registros y la evolución a lo largo del tiempo mediante gráficas de barras y de líneas. ***Traduction :*** it shows the years with the highest records and the evolution over time by means of bar and line graphs.

  #### Sección 3.4 Datos de Instituciones / Section 3.4 Institutional Data
  
  Ajusta y filtraa los datos de instituciones.

### Sección 4. Registros internacionales / Section 4. International Registrations

Analiza un poco acerca de los datos de países extranjeros, al igual que los picos de registros. ***Traduction : *** Analyze a little about the data from foreign countries, as well as the peak records.
  
---

## Licencia / License
Este proyecto está licenciado bajo la Licencia MIT. Consulte el archivo [LICENCIA](LICENCIA) para obtener más información.

***Traduction :***
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

