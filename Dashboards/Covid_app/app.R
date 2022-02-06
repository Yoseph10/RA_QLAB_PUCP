library(shiny)
library(tidyverse)
library(shinythemes)
library(zoo)
library(xts) # To make the convertion data-frame / xts format
library(dygraphs)
library(htmlwidgets)
library(webshot2)
library("RColorBrewer")   #display.brewer.all()
library(DT)
library(ggplot2)

#FINAL RESULT IS SHOWN ON THIS LINK: 

#https://qlab-pucp.shinyapps.io/PeruCovid/


################################################################################
#Importing and cleaning data 
################################################################################

#setwd("C:/Q_lab/R_shiny/Covid_dashboard/Dashboard5")
nacional<- read.csv("covid_nacional_final.csv")
nacional <- nacional[,-1] #Delete first column

departamento<- read.csv("covid_departamento_final.csv")
departamento <- departamento[,-1] #Delete first column

distrito<- read.csv("covid_distrito_final.csv", encoding = "UTF-8")
distrito <- distrito[,-1] #Delete first column

provincia<- read.csv("covid_provincia_final.csv", encoding = "UTF-8" )
provincia <- provincia[,-1] #Delete first column

panel_nacional<- read.csv("_nacional_panel_.csv")
panel_nacional<- panel_nacional[,-1] #Delete first column

panel_departamento<- read.csv("_departamento_panel_.csv")
panel_departamento<- panel_departamento[,-1] #Delete first column

panel_distrito<- read.csv("_distrito_panel_.csv", encoding = "UTF-8")
panel_distrito <- panel_distrito[,-1] #Delete first column

panel_provincia<- read.csv("_provincia_panel_.csv", encoding = "UTF-8")
panel_provincia<- panel_provincia[,-1] #Delete first column

#transform year and month in "yearmon" format
panel_distrito$ym <- as.yearmon(as.character(panel_distrito$FECHA), "%Y%m")
panel_departamento$ym <- as.yearmon(as.character(panel_departamento$FECHA), "%Y%m")
panel_provincia$ym <- as.yearmon(as.character(panel_provincia$FECHA), "%Y%m")
panel_nacional$ym <- as.yearmon(as.character(panel_nacional$FECHA), "%Y%m")

#transform ym in "Date" format
panel_distrito$FECHA_ <- as.Date(panel_distrito$ym)
panel_departamento$FECHA_ <- as.Date(panel_departamento$ym)
panel_provincia$FECHA_ <- as.Date(panel_provincia$ym)
panel_nacional$FECHA_<- as.Date(panel_nacional$ym)

#Colors for time series
my_colors <- RColorBrewer::brewer.pal(3, "Dark2")[1:3]  #Verde, naraja, morado


#Update date
a = "01/12/21"

#Collection start date
b = "01/03/20"


################################################################################
#Creating our app
################################################################################

ui <- fluidPage( theme = shinytheme("journal"),

                 titlePanel("QLAB-COVID"),
                 
                 sidebarLayout(
                         sidebarPanel(
                                 radioButtons(inputId="button",label="Nivel de los datos:",choices=c("Nacional", "Departamental", "Provincial", "Distrital"))
                                 , width = 2,
                                 
                                 p("Última actualización:"),
                                 p(strong(a)),
                                 
                                 style="text-align:left;color:black"
                         ),
                         
                         
                         
                         mainPanel(
                                 tabsetPanel(id= "tabs",
                                             
                                             #Info general
                                             tabPanel("Información general",

                                                      #Remueve el "search" en las tablas
                                                      #tags$head(
                                                       #       tags$style(type="text/css", ".dataTables_filter {display: none;    }"
                                                        #      )),

                                                      fluidRow(
                                                              
                                                              column(br(), br(),
                                                                     tags$img(src="covid19.png",width="180px",height="190px")
                                                                     
                                                                     ,width=3,style="text-align:center; padding-top: 50px"),
                                                              
                                                              column(9,
                                                                     
                                                                     br(),
                                                                     br(),
                                                                     
                                                                     p("QLAB-PUCP presenta su dashboard para analizar la evolución del Covid-19 en el Perú. 
                                                                       El dashboard permite visualizar y descargar información desagregada sobre la incidencia de la epidemia del Covid-19 en el país.
                                                                       Los niveles de agregación disponibles son departamental, provincial y distrital. 
                                                                       Para estos tres niveles, es posible visualizar la evolución de diversos indicadores, así como descargar los datos panel mensuales. 
                                                                       Con este dashboard, QLAB-PUCP busca facilitar el acceso a información sobre la epidemia en el país y así promover la investigación científica.", 
                                                                       style="text-align:justify;color:black;background-color:#fcebeb;padding:15px;border-radius:10px"),
                                                                     
                                                                     br(),
                                                                     p("Los datos que se utilizaron para la elaboración del dashboard provienen de tres fuentes. La primera fuente son los", strong(tags$a(href="https://www.minsa.gob.pe/datosabiertos/", "datos abiertos del MINSA"
                                                                                                                                                                                                            , target="_blank", style="color:black; text-decoration: underline")),
                                                                       ", de esta fuente se obtuvo información sobre los casos positivos y fallecidos por la Covid-19 en el país. La segunda fuente es el", strong(tags$a(href="https://censos2017.inei.gob.pe/redatam/", "REDATAM del INEI", target="_blank", style="color:black; text-decoration: underline")), 
                                                                       ", la cual fue usada para conocer la población a nivel departamental, provincial y distrital. Finalmente, use utilizaron los datos del", strong(tags$a(href="https://www.datosabiertos.gob.pe/dataset/informaci%C3%B3n-de-fallecidos-del-sistema-inform%C3%A1tico-nacional-de-defunciones-sinadef-ministerio", "SINADEF", target="_blank", style="color:black; text-decoration: underline")),
                                                                       "para conseguir la información sobre el número de muertes totales en el país.",
                                                                       style="text-align:justify;color:black;background-color:#fcebeb;padding:15px;border-radius:10px")
                                                                     
                                                              ),
                                                              
                                                              column(12,
                                                                     br(),br(),br(),br(),br(),br(),br(),
                                                                     p(br(),tags$img(src="pucp-qlab.png",width="320px",height="60px"), style="text-align:right")   
                                                                     #p(em("Desarrollado por"),br(),tags$img(src="pucp-qlab.png",width="320px",height="60px"), style="text-align:right; font-family: times")      
                                                              )
                                                      )
                                             ),
                                             
                                             #A nivel nacional
                                             tabPanel("Nacional", 
                                                      
                                                      fluidRow(
                                                        
                                                        column(9,
                                                               br(),
                                                               
                                                               radioButtons(inputId="nac_button",label="Elige lo que desees visualizar:",choices=c("Datos acumulados", "Serie de tiempo", "Datos panel")), #ojo coma
                                                        )
                                                      ),
                                                      
                                                      conditionalPanel(
                                                        condition = "input.nac_button == 'Datos acumulados'",
                                                        
                                                        column(12, style= "font-size: 14px;",
                                                               
                                                               br(), br(),
                                                               
                                                               tags$head(
                                                                 tags$style(HTML('#data_stock_nac1{
                                                                                        padding: 1px;
                                                                                        vertical-align: top;
                                                                                        border-top: 2px solid #d9d4d4;
                                                                                        border-bottom: 2px solid #d9d4d4;
                                                                                        text-align:left
                                                                                        }'))
                                                               ),
                                                               
                                                               tableOutput("data_stock_nac1")),
                                                        
                                                        fluidRow(style= "font-size: 13px",
                                                                 column(8, 
                                                                        
                                                                        br(),br(),br(),
                                                                        p(em(strong("Sobre las variables:")), br(), br(),
                                                                          strong("Casos:"), "Número de personas que dieron positivo a la Covid-19 (MINSA)", br(),
                                                                          strong("Muertes:"), "Cantidad de muertos por la Covid-19 (MINSA)", br(),
                                                                          strong("Muertes totales:"), "Cantidad de muertos independientemente de la causa (SINADEF)", br(),
                                                                          strong("Contagios(%):"), "(Casos/Población)*100", br(),
                                                                          strong("Mortalidad(%):"), "(Muertes/Casos)*100", br(),
                                                                          strong("Muertes Covid(%):"), "(Muertes/Muertes totales)*100",
                                                                          style="text-align:left;color:black;background-color:#fcebeb;padding:15px;border-radius:10px")),
                                                                 
                                                                 column(11, 
                                                                        
                                                                        br(),
                                                                        p(em(strong("Nota:")),"El número de casos, muertes y muertes totales acumulados corresponden al periodo comprendido entre el", strong(b), "y el", strong(a),
                                                                          style="text-align:left;color:black;background-color:#fcebeb;padding:15px;border-radius:10px"))
                                                        )
                                                      ),  
                                                      
                                                      conditionalPanel(
                                                        condition = "input.nac_button == 'Serie de tiempo'",
                                                        
                                                        fluidRow(
                                                          
                                                          column(12,
                                                                 
                                                                 br(),
                                                                 sliderInput(inputId="nac_year",
                                                                             label="Selecciona el rango de tiempo:",
                                                                             min= min(panel_nacional$FECHA_),
                                                                             max= max(panel_nacional$FECHA_),
                                                                             value= c(min(panel_nacional$FECHA_),max(panel_nacional$FECHA_)),
                                                                             width='50%',
                                                                             timeFormat= "%b %Y"),
                                                                 
                                                                 radioButtons(inputId="nac_grafico",label="Elige el gráfico:",choices=c("Evolución del Covid-19", "Evolución de muertes", "Exceso de muertes")),
                                                                 br(),
                                                                 tags$head(
                                                                   tags$style(HTML('#Descargar_serie1_nac{color:black;background-color:white;border-color:#807e7e}'))
                                                                 ),
                                                                 downloadButton("Descargar_serie1_nac", "Descargar.png"),
                                                                 br(),
                                                                 dygraphOutput("serie_nacional"))#ojo coma

                                                          
                                                        ),
                                                      
                                                        conditionalPanel(
                                                          condition = "input.nac_grafico == 'Evolución del Covid-19'",
                                                          
                                                          fluidRow(
                                                            
                                                            column(12,style= "font-size: 14px",
                                                                   
                                                                   p("Fuente: Elaboración propia basada en MINSA y SINADEF",
                                                                     style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                            
                                                            column(6, style= "font-size: 13px",
                                                                   
                                                                   p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                     style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                            
                                                          )
                                                        ),
                                                        
                                                        
                                                        conditionalPanel(
                                                          condition = "input.nac_grafico == 'Evolución de muertes'",
                                                          
                                                          fluidRow(
                                                            
                                                            column(12,style= "font-size: 14px",
                                                                   
                                                                   p("Fuente: Elaboración propia basada en MINSA y SINADEF",
                                                                     style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                            
                                                            column(6, style= "font-size: 13px",
                                                                   
                                                                   p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                     style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                            
                                                          )
                                                        ),
                                                        
                                                        conditionalPanel(
                                                          condition = "input.nac_grafico == 'Exceso de muertes'",
                                                          
                                                          fluidRow(
                                                            
                                                            column(12,style= "font-size: 14px",
                                                                   
                                                                   p("Fuente: Elaboración propia basada en SINADEF",
                                                                     style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                            
                                                            column(6, style= "font-size: 13px",
                                                                   
                                                                   p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                     style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                            
                                                          )
                                                        )  
                                                      ),
                                                      
                                                      
                                                      conditionalPanel(
                                                        condition = "input.nac_button == 'Datos panel'",
                                                        
                                                        tags$head(
                                                          tags$style(HTML('#download_data_panel_nac1{color:black;background-color:white;border-color:#807e7e}'))
                                                        ),
                                                        downloadButton("download_data_panel_nac1", "Descargar.csv"),
                                                        
                                                        tags$style(".fa-database {color:#e04141}"),
                                                        h3(p(em("Base panel"),icon("database",lib = "font-awesome"),style="color:black;text-align:center")),
                                                        
                                                        fluidRow(
                                                          
                                                          column(12, style= "font-size: 14px",
                                                                 
                                                                 br(),
                                                                 dataTableOutput("data_panel_nac1")),
                                                          
                                                          column(7, style= "font-size: 13px",
                                                                 
                                                                 br(),
                                                                 p(em(strong("Nota:")),"Panel mensual con información disponible entre el", strong(b), "y el", strong(a),
                                                                   style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                        )
                                                      ), 
                                             ),
                                             
                                             #A nivel departamental
                                             #DEPARTAMENTO
                                             tabPanel("Departamento", 
                                                      fluidRow(
                                                              
                                                              column(3,
                                                                     br(),
                                                                     
                                                                     selectizeInput('select_dep', 'Departamento:', choices = c(departamento$DEPARTAMENTO)),
                                                              )
                                                      ),
                                                      
                                                      radioButtons(inputId="dep_button",label="Elige lo que desees visualizar:",choices=c("Datos acumulados", "Serie de tiempo", "Datos panel")),
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dep_button == 'Datos acumulados'",
                                                              
                                                              column(12, style= "font-size: 14px;",
                                                                     
                                                                     br(), br(),
                                                                     
                                                                     tags$head(
                                                                             tags$style(HTML('#data_stock_dep1{
                                                                                        padding: 1px;
                                                                                        vertical-align: top;
                                                                                        border-top: 2px solid #d9d4d4;
                                                                                        border-bottom: 2px solid #d9d4d4;
                                                                                        text-align:left
                                                                                        }'))
                                                                     ),
                                                                     
                                                                     tableOutput("data_stock_dep1")),
                                                              
                                                              fluidRow(style= "font-size: 13px",
                                                                       column(8, 
                                                                              
                                                                              br(),br(),br(),
                                                                              p(em(strong("Sobre las variables:")), br(), br(),
                                                                                strong("Casos:"), "Número de personas que dieron positivo a la Covid-19 (MINSA)", br(),
                                                                                strong("Muertes:"), "Cantidad de muertos por la Covid-19 (MINSA)", br(),
                                                                                strong("Muertes totales:"), "Cantidad de muertos independientemente de la causa (SINADEF)", br(),
                                                                                strong("Contagios(%):"), "(Casos/Población)*100", br(),
                                                                                strong("Mortalidad(%):"), "(Muertes/Casos)*100", br(),
                                                                                strong("Muertes Covid(%):"), "(Muertes/Muertes totales)*100",
                                                                                style="text-align:left;color:black;background-color:#fcebeb;padding:15px;border-radius:10px")),
                                                                       
                                                                       column(11, 
                                                                              
                                                                              br(),
                                                                              p(em(strong("Nota:")),"El número de casos, muertes y muertes totales acumulados corresponden al periodo comprendido entre el", strong(b), "y el", strong(a),
                                                                                style="text-align:left;color:black;background-color:#fcebeb;padding:15px;border-radius:10px"))
                                                              )
                                                      ),  
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dep_button == 'Serie de tiempo'",
                                                              
                                                              fluidRow(
                                                                      
                                                                      column(12,

                                                                             br(),
                                                                             sliderInput(inputId="dep_year",
                                                                                         label="Selecciona el rango de tiempo:",
                                                                                         min= min(panel_departamento$FECHA_),
                                                                                         max= max(panel_departamento$FECHA_),
                                                                                         value= c(min(panel_departamento$FECHA_),max(panel_departamento$FECHA_)),
                                                                                         width='50%',
                                                                                         timeFormat= "%b %Y"),
                                                                             
                                                                             radioButtons(inputId="dep_grafico",label="Elige el gráfico:",choices=c("Evolución del Covid-19", "Evolución de muertes", "Exceso de muertes")),
                                                                             br(),
                                                                             tags$head(
                                                                                     tags$style(HTML('#Descargar_serie1{color:black;background-color:white;border-color:#807e7e}'))
                                                                             ),
                                                                             downloadButton("Descargar_serie1", "Descargar.png"),
                                                                             br(),
                                                                             dygraphOutput("serie_departamento")) #ojo coma
  
                                                              ),
                                                              
                                                              conditionalPanel(
                                                                condition = "input.dep_grafico == 'Evolución del Covid-19'",
                                                                
                                                                fluidRow(
                                                                  
                                                                  column(12,style= "font-size: 14px",
                                                                         
                                                                         p("Fuente: Elaboración propia basada en MINSA y SINADEF",
                                                                           style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                                  
                                                                  column(6, style= "font-size: 13px",
                                                                         
                                                                         p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                           style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                                  
                                                                )
                                                              ),
                                                              
                                                              
                                                              conditionalPanel(
                                                                condition = "input.dep_grafico == 'Evolución de muertes'",
                                                                
                                                                fluidRow(
                                                                  
                                                                  column(12,style= "font-size: 14px",
                                                                         
                                                                         p("Fuente: Elaboración propia basada en MINSA y SINADEF",
                                                                           style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                                  
                                                                  column(6, style= "font-size: 13px",
                                                                         
                                                                         p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                           style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                                  
                                                                )
                                                              ),
                                                              
                                                              conditionalPanel(
                                                                condition = "input.dep_grafico == 'Exceso de muertes'",
                                                                
                                                                fluidRow(
                                                                  
                                                                  column(12,style= "font-size: 14px",
                                                                         
                                                                         p("Fuente: Elaboración propia basada en SINADEF",
                                                                           style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                                  
                                                                  column(6, style= "font-size: 13px",
                                                                         
                                                                         p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                           style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                                  
                                                                )
                                                              )  
                                                      ),

                                                      
                                                      conditionalPanel(
                                                              condition = "input.dep_button == 'Datos panel'",
                                                              
                                                              tags$head(
                                                                      tags$style(HTML('#download_data_panel_dep1{color:black;background-color:white;border-color:#807e7e}'))
                                                              ),
                                                              downloadButton("download_data_panel_dep1", "Descargar.csv"),
                                                              
                                                              fluidRow(
                                                                      
                                                                      column(12, style= "font-size: 14px",
                                                                             
                                                                             br(),br(),
                                                                             dataTableOutput("data_panel_dep1")),
                                                                      
                                                                      column(7, style= "font-size: 13px",
                                                                             
                                                                             br(),
                                                                             p(em(strong("Nota:")),"Panel mensual con información disponible entre el", strong(b), "y el", strong(a),
                                                                               style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                              )
                                                      ), 
       
                                             ),
                                             
                                             #TODOS LOS DEPARTAMENTOS
                                             tabPanel("Todos los departamentos",
                                                      
                                                      fluidRow(
                                                              
                                                              column(6,
                                                                     br(),
                                                                     
                                                                     radioButtons(inputId="dep2_button",label="Elige lo que desees visualizar",choices=c("Mapa coroplético", "Datos acumulados", "Datos panel"))
                                                              )
                                                      ),
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dep2_button == 'Mapa coroplético'",
                                                              
                                                              fluidRow(
                                                                      
                                                                      column(br(),
                                                                             tags$img(src="map_dep.png",width="650px",height="700px")
                                                                             
                                                                             ,width=12,style="text-align:center; padding-top: 0px")
                                                              )
                                                              
                                                      ),
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dep2_button == 'Datos acumulados'",
                                                              
                                                              
                                                              tags$head(
                                                                      tags$style(HTML('#download_data_stock_dep2{color:black;background-color:white;border-color:#807e7e}'))
                                                              ),
                                                              downloadButton("download_data_stock_dep2", "Descargar.csv"),
                                                              
                                                              
                                                              tags$style(".fa-database {color:#e04141}"),
                                                              h3(p(em("Base con datos acumulados"),icon("database",lib = "font-awesome"),style="color:black;text-align:center")),
                                                              
                                                              fluidRow(style= "font-size: 14.5px",
                                                                       column(br(),
                                                                              DT::dataTableOutput( "data_stock_dep2" )
                                                                              ,width = 12),
                                                                       
                                                                       
                                                                       column(11, style= "font-size: 13px",
                                                                              
                                                                              br(),
                                                                              p(em(strong("Nota:")),"El número de casos, muertes y muertes totales acumulados corresponden al periodo comprendido entre el", strong(b), "y el", strong(a),
                                                                                style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                                       
                                                              ) #OJO CON COMA
                                                      ), 
                                                      
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dep2_button == 'Datos panel'",
                                                              
                                                              tags$head(
                                                                      tags$style(HTML('#download_data_panel_dep2{color:black;background-color:white;border-color:#807e7e}'))
                                                              ),
                                                              downloadButton("download_data_panel_dep2", "Descargar.csv"),
                                                              
                                                              
                                                              tags$style(".fa-database {color:#e04141}"),
                                                              h3(p(em("Base panel"),icon("database",lib = "font-awesome"),style="color:black;text-align:center")),
                                                              
                                                              fluidRow(style= "font-size: 14.5px",
                                                                       column(br(),
                                                                              DT::dataTableOutput( "data_panel_dep2" )
                                                                              ,width = 12),
                                                                       
                                                                       
                                                                       column(7, style= "font-size: 13px",
                                                                              
                                                                              br(),
                                                                              p(em(strong("Nota:")),"Panel mensual con información disponible entre el", strong(b), "y el", strong(a),
                                                                                style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                                       
                                                              )
                                                              
                                                      ), 
                                             ),
                                             
                                             #A nivel provincial
                                             #PROVINCIA
                                             tabPanel("Provincia",
                                                      
                                                      fluidRow(
                                                        
                                                        br(),
                                                        
                                                        column(3,
                                                               selectizeInput('panel_dep1', 'Departamento:', choices = c(departamento$DEPARTAMENTO)),
                                                        ),
                                                        
                                                        column(3,
                                                               selectizeInput('panel_prov1', 'Provincia:', choices = NULL),
                                                        )
                                                      ),
                                                      
                                                      radioButtons(inputId="prov_button",label="Elige lo que desees visualizar:",choices=c("Datos acumulados", "Serie de tiempo", "Datos panel")),
                                                      
                                                      conditionalPanel(
                                                        condition = "input.prov_button == 'Datos acumulados'",
                                                        
                                                        column(12, style= "font-size: 14px",
                                                               
                                                               br(), br(),
                                                               
                                                               tags$head(
                                                                 tags$style(HTML('#data_stock_prov1{
                                                                                padding: 1px;
                                                                                vertical-align: top;
                                                                                border-top: 2px solid #d9d4d4;
                                                                                border-bottom: 2px solid #d9d4d4;
                                                                                text-align:left
                                                                                }'))
                                                               ),
                                                               
                                                               tableOutput("data_stock_prov1")),
                                                        
                                                        fluidRow(style= "font-size: 13px",
                                                                 column(8, 
                                                                        
                                                                        br(),br(),br(),
                                                                        p(em(strong("Sobre las variables:")), br(), br(),
                                                                          strong("Casos:"), "Número de personas que dieron positivo a la Covid-19 (MINSA)", br(),
                                                                          strong("Muertes:"), "Cantidad de muertos por la Covid-19 (MINSA)", br(),
                                                                          strong("Muertes totales:"), "Cantidad de muertos independientemente de la causa (SINADEF)", br(),
                                                                          strong("Contagios(%):"), "(Casos/Población)*100", br(),
                                                                          strong("Mortalidad(%):"), "(Muertes/Casos)*100", br(),
                                                                          strong("Muertes Covid(%):"), "(Muertes/Muertes totales)*100",
                                                                          style="text-align:left;color:black;background-color:#fcebeb;padding:15px;border-radius:10px")),
                                                                 
                                                                 column(11, 
                                                                        
                                                                        br(),
                                                                        p(em(strong("Nota:")),"El número de casos, muertes y muertes totales acumulados corresponden al periodo comprendido entre el", strong(b), "y el", strong(a),
                                                                          style="text-align:left;color:black;background-color:#fcebeb;padding:15px;border-radius:10px"))
                                                        )
                                                      ),  
                                                      
                                                      
                                                      conditionalPanel(
                                                        condition = "input.prov_button == 'Serie de tiempo'",
                                                        
                                                        fluidRow(
                                                          
                                                          column(12,
                                                                 
                                                                 br(),
                                                                 sliderInput(inputId="year1",
                                                                             label="Selecciona el rango de tiempo:",
                                                                             min= min(panel_provincia$FECHA_),
                                                                             max= max(panel_provincia$FECHA_),
                                                                             value= c(min(panel_distrito$FECHA_), max(panel_provincia$FECHA_)),
                                                                             width='50%',
                                                                             timeFormat= "%b %Y"),
                                                                 
                                                                 radioButtons(inputId="prov_grafico",label="Elige el gráfico:",choices=c("Evolución del Covid-19", "Evolución de muertes", "Exceso de muertes")),
                                                                 br(),
                                                                 tags$head(
                                                                   tags$style(HTML('#Descargar_serie2_prov{color:black;background-color:white;border-color:#807e7e}'))
                                                                 ),
                                                                 downloadButton("Descargar_serie2_prov", "Descargar.png"),
                                                                 br(),
                                                                 dygraphOutput("serie_provincia")) #ojo coma
                                                          
                                                        ),
                                                        
                                                        conditionalPanel(
                                                          condition = "input.prov_grafico == 'Evolución del Covid-19'",
                                                          
                                                          fluidRow(
                                                            
                                                            column(12,style= "font-size: 14px",
                                                                   
                                                                   p("Fuente: Elaboración propia basada en MINSA y SINADEF",
                                                                     style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                            
                                                            column(6, style= "font-size: 13px",
                                                                   
                                                                   p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                     style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                            
                                                          )
                                                        ),
                                                        
                                                        
                                                        conditionalPanel(
                                                          condition = "input.prov_grafico == 'Evolución de muertes'",
                                                          
                                                          fluidRow(
                                                            
                                                            column(12,style= "font-size: 14px",
                                                                   
                                                                   p("Fuente: Elaboración propia basada en MINSA y SINADEF",
                                                                     style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                            
                                                            column(6, style= "font-size: 13px",
                                                                   
                                                                   p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                     style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                            
                                                          )
                                                        ),
                                                        
                                                        conditionalPanel(
                                                          condition = "input.prov_grafico == 'Exceso de muertes'",
                                                          
                                                          fluidRow(
                                                            
                                                            column(12,style= "font-size: 14px",
                                                                   
                                                                   p("Fuente: Elaboración propia basada en SINADEF",
                                                                     style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                            
                                                            column(6, style= "font-size: 13px",
                                                                   
                                                                   p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                     style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                            
                                                          )
                                                        )  
                                                        
                                                      ),
                                                      
                                                      
                                                      conditionalPanel(
                                                        condition = "input.prov_button == 'Datos panel'",
                                                        
                                                        tags$head(
                                                          tags$style(HTML('#download_data_panel_prov1{color:black;background-color:white;border-color:#807e7e}'))
                                                        ),
                                                        downloadButton("download_data_panel_prov1", "Descargar.csv"),
                                                        
                                                        fluidRow(
                                                          
                                                          column(12, style= "font-size: 14px",
                                                                 
                                                                 br(),br(),
                                                                 dataTableOutput("data_panel_prov1")),
                                                          
                                                          column(7, style= "font-size: 13px",
                                                                 
                                                                 br(),
                                                                 p(em(strong("Nota:")),"Panel mensual con información disponible entre el", strong(b), "y el", strong(a),
                                                                   style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                        )
                                                        
                                                      ), 
                                                      
                                             ),
                                             
 
                                             #TODAS LAS PROVINCIAS
                                             tabPanel("Todas las provincias", 
                                                      
                                                      fluidRow(
                                                        
                                                        column(6,
                                                               br(),
                                                               
                                                               radioButtons(inputId="prov2_button",label="Elige lo que desees visualizar:",choices=c("Mapa coroplético","Datos acumulados", "Datos panel"))
                                                        )
                                                      ),
                                                      
                                                      conditionalPanel(
                                                              condition = "input.prov2_button == 'Mapa coroplético'",
                                                              
                                                              fluidRow(
                                                                      
                                                                      column(br(),
                                                                             tags$img(src="map_prov.png",width="650px",height="700px")
                                                                             
                                                                             ,width=12,style="text-align:center; padding-top: 0px")
                                                              )
                                                              
                                                      ),
                                                      
                                                      conditionalPanel(
                                                        condition = "input.prov2_button == 'Datos acumulados'",
                                                        
                                                        tags$head(
                                                          tags$style(HTML('#download_data_stock_prov2{color:black;background-color:white;border-color:#807e7e}'))
                                                        ),
                                                        downloadButton("download_data_stock_prov2", "Descargar.csv"),
                                                        
                                                        tags$style(".fa-database {color:#e04141}"),
                                                        h3(p(em("Base con datos acumulados"),icon("database",lib = "font-awesome"),style="color:black;text-align:center")),
                                                        
                                                        
                                                        fluidRow(column(style= "font-size: 11px",
                                                                        br(),
                                                                        DT::dataTableOutput( "data_stock_prov2" )
                                                                        ,width = 12),
                                                                 
                                                                 
                                                                 column(11, style= "font-size: 13px",
                                                                        
                                                                        br(),
                                                                        p(em(strong("Nota:")), br(),
                                                                          "El número de casos, muertes y muertes totales acumulados corresponden al periodo comprendido entre el", strong(b), "y el", strong(a),
                                                                          style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px",
                                                                          
                                                                          br(),
                                                                          "El código hace referencia al UBIGEO del distrito según el INEI"))
                                                        ) 
                                                        
                                                      ), 
                                                      
                                                      
                                                      conditionalPanel(
                                                        condition = "input.prov2_button == 'Datos panel'",
                                                        
                                                        tags$head(
                                                          tags$style(HTML('#download_data_panel_prov2{color:black;background-color:white;border-color:#807e7e}'))
                                                        ),
                                                        downloadButton("download_data_panel_prov2", "Descargar.csv"),
                                                        
                                                        tags$style(".fa-database {color:#e04141}"),
                                                        h3(p(em("Base panel"),icon("database",lib = "font-awesome"),style="color:black;text-align:center")),
                                                        
                                                        
                                                        fluidRow(column(style= "font-size: 14.5px",
                                                                        br(),
                                                                        DT::dataTableOutput( "data_panel_prov2" )
                                                                        ,width = 12),
                                                                 
                                                                 
                                                                 column(7, style= "font-size: 13px",
                                                                        
                                                                        br(),
                                                                        p(em(strong("Nota:")), br(),
                                                                          "Panel mensual con información disponible entre el", strong(b), "y el", strong(a),
                                                                          
                                                                          br(),
                                                                          "El código hace referencia al UBIGEO del distrito según el INEI",
                                                                          style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                        )
                                                        
                                                      ),
                                                      
                                             ),
                                             
                                             
                                             
                                             #A nivel distrital
                                             #DISTRITO
                                             tabPanel("Distrito",
                                                      
                                                      fluidRow(
                                                              
                                                              br(),
                                                              
                                                              column(3,
                                                                     selectizeInput('panel_dep', 'Departamento:', choices = c(departamento$DEPARTAMENTO)),
                                                              ),
                                                              
                                                              column(3,
                                                                     selectizeInput('panel_prov', 'Provincia:', choices = NULL),
                                                              ),
                                                              
                                                              column(3,
                                                                     selectizeInput('panel_dis', 'Distrito:', choices = NULL),
                                                              )
                                                      ),
                                                      
                                                      radioButtons(inputId="dis_button",label="Elige lo que desees visualizar:",choices=c("Datos acumulados", "Serie de tiempo", "Datos panel")),
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dis_button == 'Datos acumulados'",
                                                              
                                                              column(12, style= "font-size: 14px",
                                                                     
                                                                     br(), br(),
                                                                     
                                                                     tags$head(
                                                                             tags$style(HTML('#data_stock_dis1{
                                                                                padding: 1px;
                                                                                vertical-align: top;
                                                                                border-top: 2px solid #d9d4d4;
                                                                                border-bottom: 2px solid #d9d4d4;
                                                                                text-align:left
                                                                                }'))
                                                                     ),
                                                                     
                                                                     tableOutput("data_stock_dis1")),
                                                              
                                                              fluidRow(style= "font-size: 13px",
                                                                       column(8, 
                                                                              
                                                                              br(),br(),br(),
                                                                              p(em(strong("Sobre las variables:")), br(), br(),
                                                                                strong("Casos:"), "Número de personas que dieron positivo a la Covid-19 (MINSA)", br(),
                                                                                strong("Muertes:"), "Cantidad de muertos por la Covid-19 (MINSA)", br(),
                                                                                strong("Muertes totales:"), "Cantidad de muertos independientemente de la causa (SINADEF)", br(),
                                                                                strong("Contagios(%):"), "(Casos/Población)*100", br(),
                                                                                strong("Mortalidad(%):"), "(Muertes/Casos)*100", br(),
                                                                                strong("Muertes Covid(%):"), "(Muertes/Muertes totales)*100",
                                                                                style="text-align:left;color:black;background-color:#fcebeb;padding:15px;border-radius:10px")),
                                                                       
                                                                       column(11, 
                                                                              
                                                                              br(),
                                                                              p(em(strong("Nota:")),"El número de casos, muertes y muertes totales acumulados corresponden al periodo comprendido entre el", strong(b), "y el", strong(a),
                                                                                style="text-align:left;color:black;background-color:#fcebeb;padding:15px;border-radius:10px"))
                                                              )
                                                      ),  
                                                      
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dis_button == 'Serie de tiempo'",
                                                              
                                                              fluidRow(
                                                                      
                                                                      column(12,
                                                                             
                                                                             br(),
                                                                             sliderInput(inputId="year",
                                                                                         label="Selecciona el rango de tiempo:",
                                                                                         min= min(panel_distrito$FECHA_),
                                                                                         max= max(panel_distrito$FECHA_),
                                                                                         value= c(min(panel_distrito$FECHA_), max(panel_distrito$FECHA_)),
                                                                                         width='50%',
                                                                                         timeFormat= "%b %Y"),

                                                                             radioButtons(inputId="dis_grafico",label="Elige el gráfico:",choices=c("Evolución del Covid-19", "Evolución de muertes", "Exceso de muertes")),
                                                                             br(),
                                                                             tags$head(
                                                                                     tags$style(HTML('#Descargar_serie2{color:black;background-color:white;border-color:#807e7e}'))
                                                                             ),
                                                                             downloadButton("Descargar_serie2", "Descargar.png"),
                                                                             br(),
                                                                             dygraphOutput("serie_distrito"))#ojo coma
                                                                             
                                                              ),
                                                              
                                                              conditionalPanel(
                                                                condition = "input.dis_grafico == 'Evolución del Covid-19'",
                                                                
                                                                fluidRow(
                                                                  
                                                                  column(12,style= "font-size: 14px",
                                                                         
                                                                         p("Fuente: Elaboración propia basada en MINSA y SINADEF",
                                                                           style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                                  
                                                                  column(6, style= "font-size: 13px",
                                                                         
                                                                         p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                         style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))

                                                                )
                                                              ),
                                                              
                                                              
                                                              conditionalPanel(
                                                                condition = "input.dis_grafico == 'Evolución de muertes'",
                                                                
                                                                fluidRow(
                                                                  
                                                                  column(12,style= "font-size: 14px",
                                                                         
                                                                         p("Fuente: Elaboración propia basada en MINSA y SINADEF",
                                                                           style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                                  
                                                                  column(6, style= "font-size: 13px",
                                                                         
                                                                         p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                           style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                                  
                                                                )
                                                              ),
                                                              
                                                              conditionalPanel(
                                                                condition = "input.dis_grafico == 'Exceso de muertes'",
                                                                
                                                                fluidRow(
                                                                  
                                                                  column(12,style= "font-size: 14px",
                                                                         
                                                                         p("Fuente: Elaboración propia basada en SINADEF",
                                                                           style="text-align:right;color:black;background-color:white;padding:15px;border-radius:10px;font-family: times") ),
                                                                  
                                                                  column(6, style= "font-size: 13px",
                                                                         
                                                                         p(em(strong("Nota:")),"Si la imagen no carga bien, seleccionar de nuevo el rango de tiempo",
                                                                           style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                                  
                                                                )
                                                              )
                                                              
                                                              
                                                      ),
                                                      
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dis_button == 'Datos panel'",
                                                              
                                                              tags$head(
                                                                      tags$style(HTML('#download_data_panel_dis1{color:black;background-color:white;border-color:#807e7e}'))
                                                              ),
                                                              downloadButton("download_data_panel_dis1", "Descargar.csv"),
                                                              
                                                              fluidRow(
                                                                      
                                                                      column(12, style= "font-size: 14px",
                                                                             
                                                                             br(),br(),
                                                                             dataTableOutput("data_panel_dis1")),
                                                                      
                                                                      column(7, style= "font-size: 13px",
                                                                             
                                                                             br(),
                                                                             p(em(strong("Nota:")),"Panel mensual con información disponible entre el", strong(b), "y el", strong(a),
                                                                               style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                              )
                                                              
                                                      ), 
                                                      
                                             ),
                                             
                                             #TODOS LOS DISTRITOS
                                             tabPanel("Todos los distritos", 
                                                      
                                                      fluidRow(
                                                              
                                                              column(6,
                                                                     br(),
                                                                     
                                                                     radioButtons(inputId="dis2_button",label="Elige lo que desees visualizar:",choices=c("Mapa coroplético","Datos acumulados", "Datos panel"))
                                                              )
                                                      ),
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dis2_button == 'Mapa coroplético'",
                                                              
                                                              fluidRow(
                                                                      
                                                                      column(br(),
                                                                             tags$img(src="map_dist.png",width="650px",height="700px")
                                                                             
                                                                             ,width=12,style="text-align:center; padding-top: 0px"),
                                                                      
                                                                      column(7, style= "font-size: 13px",
                                                                             
                                                                             br(),
                                                                             p(em(strong("Nota:")),"Los distritos en gris son aquellos en los que no se encontró información",
                                                                               style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                              )
                                                              
                                                      ),
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dis2_button == 'Datos acumulados'",
                                                              
                                                              tags$head(
                                                                      tags$style(HTML('#download_data_stock_dis2{color:black;background-color:white;border-color:#807e7e}'))
                                                              ),
                                                              downloadButton("download_data_stock_dis2", "Descargar.csv"),
                                                              
                                                              tags$style(".fa-database {color:#e04141}"),
                                                              h3(p(em("Base con datos acumulados"),icon("database",lib = "font-awesome"),style="color:black;text-align:center")),
                                                              
                                                              
                                                              fluidRow(column(style= "font-size: 11px",
                                                                              br(),
                                                                              DT::dataTableOutput( "data_stock_dis2" )
                                                                              ,width = 12),
                                                                       
                                                                       
                                                                       column(11, style= "font-size: 13px",
                                                                              
                                                                              br(),
                                                                              p(em(strong("Nota:")), br(),
                                                                                "El número de casos, muertes y muertes totales acumulados corresponden al periodo comprendido entre el", strong(b), "y el", strong(a),
                                                                                style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px",
                                                                                
                                                                                br(),
                                                                                "El código hace referencia al UBIGEO del distrito según el INEI"))
                                                              ) 
                                                              
                                                      ), 
                                                      
                                                      
                                                      conditionalPanel(
                                                              condition = "input.dis2_button == 'Datos panel'",
                                                              
                                                              tags$head(
                                                                      tags$style(HTML('#download_data_panel_dis2{color:black;background-color:white;border-color:#807e7e}'))
                                                              ),
                                                              downloadButton("download_data_panel_dis2", "Descargar.csv"),
                                                              
                                                              tags$style(".fa-database {color:#e04141}"),
                                                              h3(p(em("Base panel"),icon("database",lib = "font-awesome"),style="color:black;text-align:center")),
                                                              
                                                              
                                                              fluidRow(column(style= "font-size: 14.5px",
                                                                              br(),
                                                                              DT::dataTableOutput( "data_panel_dis2" )
                                                                              ,width = 12),
                                                                       
                                                                       
                                                                       column(7, style= "font-size: 13px",
                                                                              
                                                                              br(),
                                                                              p(em(strong("Nota:")), br(),
                                                                                "Panel mensual con información disponible entre el", strong(b), "y el", strong(a),
                                                                                
                                                                                br(),
                                                                                "El código hace referencia al UBIGEO del distrito según el INEI",
                                                                                style="text-align:left;color:black;background-color:lavender;padding:15px;border-radius:10px"))
                                                              )
                                                              
                                                      ),
                                                      
                                             )
                                 )
                                 , style="text-align:justify;color:black")
                 )
)


server <- function(input, output, session) {
        
        
        ##################################
        #sidebarLayout
        ##################################
        
        ## observe the button being pressed
        observeEvent(input$button, {
                
                if(input$button == "Departamental"){
                        
                        showTab(inputId = "tabs", target = "Información general")
                        showTab(inputId = "tabs", target = "Departamento")
                        showTab(inputId = "tabs", target = "Todos los departamentos")
                        
                        hideTab(inputId = "tabs", target = "Distrito")
                        hideTab(inputId = "tabs", target = "Todos los distritos")
                        hideTab(inputId = "tabs", target = "Provincia")
                        hideTab(inputId = "tabs", target = "Todas las provincias")
                        hideTab(inputId = "tabs", target = "Nacional")
                
                } else if (input$button == "Provincial"){
                  
                        showTab(inputId = "tabs", target = "Información general")
                        showTab(inputId = "tabs", target = "Provincia")
                        showTab(inputId = "tabs", target = "Todas las provincias")
                        
                        hideTab(inputId = "tabs", target = "Distrito")
                        hideTab(inputId = "tabs", target = "Todos los distritos")
                        hideTab(inputId = "tabs", target = "Departamento")
                        hideTab(inputId = "tabs", target = "Todos los departamentos")
                        hideTab(inputId = "tabs", target = "Nacional")
          
                } else if (input$button == "Distrital"){
                        
                        showTab(inputId = "tabs", target = "Información general")
                        showTab(inputId = "tabs", target = "Distrito")
                        showTab(inputId = "tabs", target = "Todos los distritos")
                        
                        hideTab(inputId = "tabs", target = "Provincia")
                        hideTab(inputId = "tabs", target = "Todas las provincias")
                        hideTab(inputId = "tabs", target = "Departamento")
                        hideTab(inputId = "tabs", target = "Todos los departamentos")
                        hideTab(inputId = "tabs", target = "Nacional")
                        
                } else{
                        showTab(inputId = "tabs", target = "Información general")
                        showTab(inputId = "tabs", target = "Nacional")
                  
                        hideTab(inputId = "tabs", target = "Distrito")
                        hideTab(inputId = "tabs", target = "Todos los distritos")
                        hideTab(inputId = "tabs", target = "Departamento")
                        hideTab(inputId = "tabs", target = "Todos los departamentos")
                        hideTab(inputId = "tabs", target = "Provincia")
                        hideTab(inputId = "tabs", target = "Todas las provincias")

                }
        })
        
  
        ##################################
        #Tab: Nacional
        ##################################
        #Datos acumulados
        
        stock_nac1 <- reactive({
          table_stock_nac1 <-nacional[,c(1,2,4,6,3,5,7)]
          colnames(table_stock_nac1) = c("Población", "Casos", "Muertes", "Muertes totales", "Contagios (%)", "Mortalidad (%)", "Muertes Covid (%)")
          table_stock_nac1
        })
        
        
        output$data_stock_nac1 <- renderTable({
          stock_nac1() 
        })
        
        
        #Serie de tiempo
        
        #PARA VISUALIZAR     
        #Tres series
        nac_create_dygraph <- reactive({
          b_dep <- xts(x = panel_nacional[,c(2:4)] , order.by = panel_nacional$FECHA_)  
          g_dep <- dygraph(b_dep, main = paste("Evolución del Covid-19 en el Perú")) %>%
            dyAxis("y", label = "Número de personas") %>%
            #dyAxis("x", label = "Fecha" ) %>%
            dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
            dySeries("CASOS", color = my_colors[3], label = "Casos Covid") %>%
            dySeries("FALLECIDOS", color = "red", label = "Muertes Covid") %>%
            dySeries("FALLECIDOS_SINADEF", color = my_colors[1], label = "Muertes totales") %>%
            dyRangeSelector(dateWindow = c(input$nac_year),height = 30) %>%
            dyLegend(width = 150, labelsSeparateLines = TRUE) 
          g_dep
        })
        
        
        #Dos series
        nac_create_dygraph1 <- reactive({
          b_dep1 <- xts(x = panel_nacional[,c(3:4)] , order.by = panel_nacional$FECHA_)
          g_dep1 <- dygraph(b_dep1, main = paste("Evolución de muertes en el Perú") ) %>%
            dyAxis("y", label = "Número de personas") %>%
            #dyAxis("x", label = "Fecha" ) %>%
            dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
            dySeries("FALLECIDOS", color = "red", label = "Muertes Covid") %>%
            dySeries("FALLECIDOS_SINADEF", color = my_colors[1],label = "Muertes totales") %>%
            dyRangeSelector(dateWindow = c(input$nac_year),height = 30) %>%
            dyLegend(width = 150, labelsSeparateLines = TRUE)
          g_dep1
        })
        
        
        #Exceso de muertes serie
        nac_create_dygraph2 <- reactive({
          b_dep2 <- xts(x = panel_nacional[,6] , order.by = panel_nacional$FECHA_)
          g_dep2 <- dygraph(b_dep2, main = paste("Evolución de exceso de muertes en el Perú respecto al 2019") ) %>%
            dyAxis("y", label = "Exceso de muertes") %>%
            dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
            dySeries("V1", color = my_colors[2],label = "Exceso de muertes") %>%
            dyRangeSelector(dateWindow = c(input$nac_year),height = 30) %>%
            dyLegend(width = 150, labelsSeparateLines = TRUE)
          g_dep2
        })
        
        
        output$serie_nacional  <- renderDygraph({
          
          if(input$nac_grafico == "Evolución del Covid-19"){
            nac_create_dygraph()
            
          }else if(input$nac_grafico == "Evolución de muertes"){
            nac_create_dygraph1()
            
          }else{
            nac_create_dygraph2()

          }
        })
        
        
        #PARA DESCARGAR
        #Tres series
        plot_nac1 <- reactive({
          Data1 <- panel_nacional
          p <- ggplot(data=Data1) +
            theme_bw() +
            
            geom_point(mapping=aes(y=CASOS,x= FECHA_,color="Casos Covid"),size=2 ) +
            geom_line(mapping=aes(y=CASOS,x= FECHA_,color="Casos Covid"),size=1 ) +
            
            geom_point(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=1) +
            
            geom_point(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=1) +
            
            scale_color_manual(values = c(
              'Casos Covid' = my_colors[3] ,
              'Muertes Covid' = 'red',
              'Muertes totales'= my_colors[1] )) +
            labs(color = 'Series:') +
            scale_x_date(limit=c(input$nac_year)) +
            ggtitle(paste("Evolución del Covid-19 en el Perú")) +
            xlab("Mes") + ylab("Número de personas") 
          
          p
        })
        
        #Dos series
        plot_nac2 <- reactive({
          Data2 <- panel_nacional
          p2 <- ggplot(data=Data2) +
            theme_bw() +
            
            geom_point(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=1) +
            
            geom_point(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=1) +
            
            scale_color_manual(values = c(
              'Muertes Covid' = 'red',
              'Muertes totales'= my_colors[1] )) +
            labs(color = 'Series:') +
            scale_x_date(limit=c(input$nac_year)) +
            ggtitle(paste("Evolución de muertes en el Perú")) +
            xlab("Mes") + ylab("Número de personas") 
          
          p2
        })
        
        #exceso de muertes serie
        plot_nac3 <- reactive({
          Data3 <- panel_nacional
          p3 <- ggplot(data=Data3) +
            theme_bw() +
            
            geom_point(mapping=aes(y=EXCESO_MUERTES,x= FECHA_,color="Exceso de muertes"),size=2) +
            geom_line(mapping=aes(y=EXCESO_MUERTES,x= FECHA_,color="Exceso de muertes"),size=1) +
            
            scale_color_manual(values = c(
              'Exceso de muertes'= my_colors[2] )) +
            labs(color = 'Serie:') +
            scale_x_date(limit=c(input$nac_year)) +
            ggtitle(paste("Evolución de exceso de muertes en el Perú respecto al 2019")) +
            xlab("Mes") + ylab("Exceso de muertes") 
          
          p3
        })
        
        output$Descargar_serie1_nac <- downloadHandler(
          filename = function() {
            
            if(input$nac_grafico == "Evolución del Covid-19"){
              "Serie_covid_.png"
              
            }
            else if(input$nac_grafico == "Evolución de muertes"){
              "Serie_muertes_.png"
              
            }
            else{
              "Serie_exceso_.png"
              
            }

          },
          content = function(file) {
            device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
            
            if(input$nac_grafico == "Evolución del Covid-19"){
              ggsave(file, plot = plot_nac1(), device = device)
              
            }
            else if(input$nac_grafico == "Evolución de muertes"){
              ggsave(file, plot = plot_nac2(), device = device)
              
            } 
            else{
              ggsave(file, plot = plot_nac3(), device = device)
              
            }
          }
        )
        
        
        #Datos panel    
        
        panel_nac1 <- reactive({
          mysubset_panel_nac1 <- subset( panel_nacional[ ,c(1:4)])
          mysubset_panel_nac1$ANO <- substr(mysubset_panel_nac1$FECHA,1,4)
          mysubset_panel_nac1$MES <- substr(mysubset_panel_nac1$FECHA,5,6)
          
          mysubset_panel_nac1 <- mysubset_panel_nac1[ ,c(6,5,2,3,4)]
          colnames(mysubset_panel_nac1) = c("Mes", "Año", "Casos", "Muertes Covid", "Muertes totales")
          mysubset_panel_nac1
        })
        
        output$data_panel_nac1 <- renderDataTable(
          panel_nac1(),
          options = list(pageLength = 15, lengthChange = FALSE, searchable = FALSE, 
                         initComplete = JS(
                           "function(settings, json) {",
                           "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                           "}"))
        )
        
        output$download_data_panel_nac1 <- downloadHandler(
          filename = function() {
            "Datos_panel_.csv"
          },
          content = function(file) {
            write.csv(panel_nac1(), file, row.names = FALSE)
          }
        )

        

        ##################################
        #Tab: Departamento
        ##################################
        
        #Datos acumulados
        
        stock_dep1 <- reactive({
                table_stock_dep1 <- subset( departamento,
                                            departamento$DEPARTAMENTO == input$select_dep)
                table_stock_dep1 <-table_stock_dep1[,c(1:3,5,7,4,6,8)]
                colnames(table_stock_dep1) = c("Departamento", "Población", "Casos", "Muertes", "Muertes totales", "Contagios (%)", "Mortalidad (%)", "Muertes Covid (%)")
                table_stock_dep1
        })
        
        
        output$data_stock_dep1 <- renderTable({
                stock_dep1() 
        })
        
        
        #Serie de tiempo

        #PARA VISUALIZAR 
        #Tres series
        dep_create_dygraph <- reactive({
                mysubset_dep <- subset( panel_departamento,
                                        panel_departamento$DEPARTAMENTO == input$select_dep)
                
                b_dep <- xts(x = mysubset_dep[,c(3:5)] , order.by = mysubset_dep$FECHA_)
                g_dep <- dygraph(b_dep, main = paste("Evolución del Covid-19 en el departamento de", input$select_dep)) %>%
                        dyAxis("y", label = "Número de personas") %>%
                        #dyAxis("x", label = "Fecha" ) %>%
                        dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
                        dySeries("CASOS", color = my_colors[3], label = "Casos Covid") %>%
                        dySeries("FALLECIDOS", color = "red", label = "Muertes Covid") %>%
                        dySeries("FALLECIDOS_SINADEF", color = my_colors[1], label = "Muertes totales") %>%
                        dyRangeSelector(dateWindow = c(input$dep_year),height = 30) %>%
                        dyLegend(width = 150, labelsSeparateLines = TRUE)
                g_dep
        })
        
        
        #Dos series
        dep_create_dygraph1 <- reactive({
                mysubset_dep1 <- subset( panel_departamento,
                                         panel_departamento$DEPARTAMENTO == input$select_dep)

                b_dep1 <- xts(x = mysubset_dep1[,c(4:5)] , order.by = mysubset_dep1$FECHA_)
                g_dep1 <- dygraph(b_dep1, main = paste("Evolución de muertes en el departamento de", input$select_dep) ) %>%
                        dyAxis("y", label = "Número de personas") %>%
                        #dyAxis("x", label = "Fecha" ) %>%
                        dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
                        dySeries("FALLECIDOS", color = "red", label = "Muertes Covid") %>%
                        dySeries("FALLECIDOS_SINADEF", color = my_colors[1],label = "Muertes totales") %>%
                        dyRangeSelector(dateWindow = c(input$dep_year),height = 30) %>%
                        dyLegend(width = 150, labelsSeparateLines = TRUE)
                g_dep1
        })
        
        #Exceso de muertes serie
        dep_create_dygraph2 <- reactive({
          mysubset_dep2 <- subset( panel_departamento,
                                   panel_departamento$DEPARTAMENTO == input$select_dep)
          
          b_dep2 <- xts(x = mysubset_dep2[,7] , order.by = mysubset_dep2$FECHA_)
          g_dep2 <- dygraph(b_dep2, main = paste("Evolución de exceso de muertes en", input$select_dep, "respecto al 2019") ) %>%
            dyAxis("y", label = "Exceso de muertes") %>%
            dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
            dySeries("V1", color = my_colors[2], label = "Exceso de muertes") %>%
            dyRangeSelector(dateWindow = c(input$dep_year),height = 30) %>%
            dyLegend(width = 150, labelsSeparateLines = TRUE)
          g_dep2
        })
        
        
        output$serie_departamento  <- renderDygraph({
                
                if(input$dep_grafico == "Evolución del Covid-19"){
                        dep_create_dygraph()
    
                }
                else if(input$dep_grafico == "Evolución de muertes"){
                        dep_create_dygraph1()

                }
                else{
                  dep_create_dygraph2()
                  
                }
          
        })
     
        
        #PARA DESCARGAR
        #Tres series
        plot_dep1 <- reactive({
          Data1 <- subset( panel_departamento,
                                  panel_departamento$DEPARTAMENTO == input$select_dep)
          p <- ggplot(data=Data1) +
            theme_bw() +
            
            geom_point(mapping=aes(y=CASOS,x= FECHA_,color="Casos Covid"),size=2 ) +
            geom_line(mapping=aes(y=CASOS,x= FECHA_,color="Casos Covid"),size=1 ) +
            
            geom_point(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=1) +
            
            geom_point(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=1) +
            
            scale_color_manual(values = c(
              'Casos Covid' = my_colors[3] ,
              'Muertes Covid' = 'red',
              'Muertes totales'= my_colors[1] )) +
            labs(color = 'Series:') +
            scale_x_date(limit=c(input$dep_year)) +
            ggtitle(paste("Evolución del Covid-19 en el departamento de", input$select_dep)) +
            xlab("Mes") + ylab("Número de personas") 
          
          p
        })
        
        #Dos series
        plot_dep2 <- reactive({
          Data2 <- subset( panel_departamento,
                           panel_departamento$DEPARTAMENTO == input$select_dep)
          p2 <- ggplot(data=Data2) +
            theme_bw() +
            
            geom_point(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=1) +
            
            geom_point(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=1) +
            
            scale_color_manual(values = c(
              'Muertes Covid' = 'red',
              'Muertes totales'= my_colors[1] )) +
            labs(color = 'Series:') +
            scale_x_date(limit=c(input$dep_year)) +
            ggtitle(paste("Evolución de muertes en el departamento de", input$select_dep)) +
            xlab("Mes") + ylab("Número de personas") 
          
          p2
        })
        
        #exceso de muertes serie
        plot_dep3 <- reactive({
          Data3 <- subset( panel_departamento,
                           panel_departamento$DEPARTAMENTO == input$select_dep)
          p3 <- ggplot(data=Data3) +
            theme_bw() +
            
            geom_point(mapping=aes(y=EXCESO_MUERTES,x= FECHA_,color="Exceso de muertes"),size=2) +
            geom_line(mapping=aes(y=EXCESO_MUERTES,x= FECHA_,color="Exceso de muertes"),size=1) +
            
            scale_color_manual(values = c(
              'Exceso de muertes'= my_colors[2] )) +
            labs(color = 'Serie:') +
            scale_x_date(limit=c(input$nac_year)) +
            ggtitle(paste("Evolución de exceso de muertes en",input$select_dep, "respecto al 2019")) +
            xlab("Mes") + ylab("Exceso de muertes") 
          
          p3
        })
        
        
        output$Descargar_serie1 <- downloadHandler(
          filename = function() {
            
            if(input$dep_grafico == "Evolución del Covid-19"){
              paste0("Serie_covid_",input$select_dep,".png")
              
            }
            else if(input$dep_grafico == "Evolución de muertes"){
              paste0("Serie_muertes_",input$select_dep,".png")
              
            }else{
              paste0("Serie_exceso_",input$select_dep,".png")
              
            }

          },
          content = function(file) {
            device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
            
            if(input$dep_grafico == "Evolución del Covid-19"){
              ggsave(file, plot = plot_dep1(), device = device)
              
            }
            else if(input$dep_grafico == "Evolución de muertes"){
              ggsave(file, plot = plot_dep2(), device = device)
              
            }else{
              ggsave(file, plot = plot_dep3(), device = device)
              
            } 

          }
        )
        
        #Datos panel
        
        panel_dep1 <- reactive({
                mysubset_panel_dep1 <- subset( panel_departamento[ ,c(1:5)],
                                               panel_departamento$DEPARTAMENTO == input$select_dep)
                
                mysubset_panel_dep1$ANO <- substr(mysubset_panel_dep1$FECHA,1,4)
                mysubset_panel_dep1$MES <- substr(mysubset_panel_dep1$FECHA,5,6)
                
                mysubset_panel_dep1 <- mysubset_panel_dep1[ ,c(1,7,6,3,4,5)]
                colnames(mysubset_panel_dep1) = c("Departamento", "Mes", "Año", "Casos", "Muertes Covid", "Muertes totales")
                mysubset_panel_dep1
        })
        
        output$data_panel_dep1 <- renderDataTable(
                panel_dep1(),
                options = list(pageLength = 15, lengthChange = FALSE, searchable = FALSE, 
                               initComplete = JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                                       "}"))
        )
        
        output$download_data_panel_dep1 <- downloadHandler(
                filename = function() {
                        paste0("Datos_panel_",input$select_dep,".csv")
                },
                content = function(file) {
                        write.csv(panel_dep1(), file, row.names = FALSE)
                }
        )
        
        
        ##################################
        #Tab: Todos los departamentos
        ################################## 
        
        #Datos acumulados
        
        stock_dep2 <- reactive({
                departamento_stock_dep2 <- departamento
                departamento_stock_dep2 <-departamento_stock_dep2[,c(1:3,5,7,4,6,8)]
                colnames(departamento_stock_dep2) = c("Departamento", "Población", "Casos", "Muertes", "Muertes totales", "Contagios (%)", "Mortalidad (%)", "Muertes Covid (%)")
                departamento_stock_dep2
        })
        
        output$download_data_stock_dep2 <- downloadHandler(
                filename = function() {
                        paste("Datos_stock_departamentos.csv")
                },
                content = function(file) {
                        write.csv(stock_dep2(), file, row.names = FALSE)
                }
        )
        
        output$data_stock_dep2 <- renderDataTable(
                stock_dep2(),
                options = list(pageLength = 15, lengthChange = FALSE,
                               initComplete = JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                                       "}"))
        )
        
        
        #Datos panel
        
        panel_dep2 <- reactive({
                datos_panel_dep2 <- panel_departamento[ ,c(1:5)]
                datos_panel_dep2$ANO <- substr(datos_panel_dep2$FECHA,1,4)
                datos_panel_dep2$MES <- substr(datos_panel_dep2$FECHA,5,6)
                
                datos_panel_dep2 <- datos_panel_dep2[ ,c(1,7,6,3,4,5)]
                colnames(datos_panel_dep2) = c("Departamento", "Mes", "Año", "Casos", "Muertes Covid", "Muertes totales")
                datos_panel_dep2
        }) 
        
        
        output$download_data_panel_dep2 <- downloadHandler(
                filename = function() {
                        paste("Datos_panel_departamentos.csv")
                },
                content = function(file) {
                        write.csv(panel_dep2(), file, row.names = FALSE)
                }
        )
        
        
        output$data_panel_dep2 <- renderDataTable(
                panel_dep2(),
                options = list(pageLength = 15, lengthChange = FALSE,
                               initComplete = JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                                       "}"))
        )
        
        ##################################
        #Tab: Provincia
        ##################################
        
        #Actualizar opciones para la serie de tiempo mensual-distrital
        observe({
          x <- input$panel_dep1
          
          updateSelectizeInput(session, "panel_prov1",
                               label = 'Provincia:',
                               choices = c( provincia$PROVINCIA[provincia$DEPARTAMENTO == x ])
                               
                               
          )
        })
        
        
        #Datos acumulados
        
        stock_prov1 <- reactive({
          provincia_stock_prov1 <- subset( provincia[, c(4,2,6,8,10,7,9,11)],
                                          provincia$DEPARTAMENTO == input$panel_dep1 & provincia$PROVINCIA == input$panel_prov1)
          colnames(provincia_stock_prov1) = c("Provincia", "Población", "Casos", "Muertes", "Muertes totales", "Contagios (%)", "Mortalidad (%)", "Muertes Covid (%)")
          provincia_stock_prov1 
        })
        
        output$data_stock_prov1 <- renderTable({
          stock_prov1() 
        })
        
        
        
        #Serie de tiempo
        
        #PARA VISUALIZAR
        #Tres series
        create_dygraph_prov <- reactive({
          mysubset <- subset( panel_provincia,
                              panel_provincia$DEPARTAMENTO == input$panel_dep1 & panel_provincia$PROVINCIA == input$panel_prov1)
          
          
          b <- xts(x = mysubset[,c(5:7)] , order.by = mysubset$FECHA_)
          g <- dygraph(b, main = paste("Evolución del Covid-19 en la provincia de", input$panel_prov1) ) %>%
            dyAxis("y", label = "Número de personas") %>%
            #dyAxis("x", label = "Fecha" ) %>%
            dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
            dySeries("CASOS", color = my_colors[3], label = "Casos Covid") %>%
            dySeries("FALLECIDOS", color = "red", label = "Muertes Covid") %>%
            dySeries("FALLECIDOS_SINADEF", color = my_colors[1], label = "Muertes totales") %>%
            dyRangeSelector(dateWindow = c(input$year1),height = 30) %>%
            dyLegend(width = 150, labelsSeparateLines = TRUE)
          g
        })
        
        
        #Dos series
        create_dygraph1_prov <- reactive({
          mysubset1 <- subset( panel_provincia,
                               panel_provincia$DEPARTAMENTO == input$panel_dep1 & panel_provincia$PROVINCIA == input$panel_prov1)
          
          b1 <- xts(x = mysubset1[,c(6:7)] , order.by = mysubset1$FECHA_)
          g1 <- dygraph(b1, main = paste("Evolución de muertes en la provincia de", input$panel_prov1) ) %>%
            dyAxis("y", label = "Número de personas") %>%
            #dyAxis("x", label = "Fecha" ) %>%
            dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
            dySeries("FALLECIDOS", color = "red", label = "Muertes Covid") %>%
            dySeries("FALLECIDOS_SINADEF", color = my_colors[1],label = "Muertes totales") %>%
            dyRangeSelector(dateWindow = c(input$year1),height = 30) %>%
            dyLegend(width = 150, labelsSeparateLines = TRUE)
          g1
        })
        
        #Exceso de muertes serie
        create_dygraph2_prov <- reactive({
          mysubset_prov2 <- subset( panel_provincia,
                                   panel_provincia$DEPARTAMENTO == input$panel_dep1 & panel_provincia$PROVINCIA == input$panel_prov1)
          
          b_prov2 <- xts(x = mysubset_prov2[,9] , order.by = mysubset_prov2$FECHA_)
          g_prov2 <- dygraph(b_prov2, main = paste("Evolución de exceso de muertes en", input$panel_prov1, "respecto al 2019") ) %>%
            dyAxis("y", label = "Exceso de muertes") %>%
            dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
            dySeries("V1", color = my_colors[2], label = "Exceso de muertes") %>%
            dyRangeSelector(dateWindow = c(input$year1),height = 30) %>%
            dyLegend(width = 150, labelsSeparateLines = TRUE)
          g_prov2
        })
        
        output$serie_provincia  <- renderDygraph({
          
          if(input$prov_grafico == "Evolución del Covid-19"){
            create_dygraph_prov()
            
          }
          else if(input$prov_grafico == "Evolución de muertes"){
            create_dygraph1_prov()
          }
          else{
            create_dygraph2_prov()
          }
          
        })
        
        
        #PARA DESCARGAR
        #Tres series
        plot_prov1 <- reactive({
          Data1 <- subset( panel_provincia,
                           panel_provincia$DEPARTAMENTO == input$panel_dep1 & panel_provincia$PROVINCIA == input$panel_prov1)
          p <- ggplot(data=Data1) +
            theme_bw() +
            
            geom_point(mapping=aes(y=CASOS,x= FECHA_,color="Casos Covid"),size=2 ) +
            geom_line(mapping=aes(y=CASOS,x= FECHA_,color="Casos Covid"),size=1 ) +
            
            geom_point(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=1) +
            
            geom_point(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=1) +
            
            scale_color_manual(values = c(
              'Casos Covid' = my_colors[3] ,
              'Muertes Covid' = 'red',
              'Muertes totales'= my_colors[1] )) +
            labs(color = 'Series:') +
            scale_x_date(limit=c(input$year1)) +
            ggtitle(paste("Evolución del Covid-19 en la provincia de", input$panel_prov1)) +
            xlab("Mes") + ylab("Número de personas") 
          
          p
        })
        
        #Dos series
        plot_prov2 <- reactive({
          Data2 <- subset( panel_provincia,
                           panel_provincia$DEPARTAMENTO == input$panel_dep1 & panel_provincia$PROVINCIA == input$panel_prov1)
          p2 <- ggplot(data=Data2) +
            theme_bw() +
            
            geom_point(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=1) +
            
            geom_point(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=1) +
            
            scale_color_manual(values = c(
              'Muertes Covid' = 'red',
              'Muertes totales'= my_colors[1] )) +
            labs(color = 'Series:') +
            scale_x_date(limit=c(input$year1)) +
            ggtitle(paste("Evolución de muertes en la provincia de", input$panel_prov1)) +
            xlab("Mes") + ylab("Número de personas") 
          
          p2
        })
        
        #exceso de muertes serie
        plot_prov3 <- reactive({
          Data3 <- subset( panel_provincia,
                           panel_provincia$DEPARTAMENTO == input$panel_dep1 & panel_provincia$PROVINCIA == input$panel_prov1)
          p3 <- ggplot(data=Data3) +
            theme_bw() +
            
            geom_point(mapping=aes(y=EXCESO_MUERTES,x= FECHA_,color="Exceso de muertes"),size=2) +
            geom_line(mapping=aes(y=EXCESO_MUERTES,x= FECHA_,color="Exceso de muertes"),size=1) +
            
            scale_color_manual(values = c(
              'Exceso de muertes'= my_colors[2] )) +
            labs(color = 'Serie:') +
            scale_x_date(limit=c(input$year1)) +
            ggtitle(paste("Evolución de exceso de muertes en",input$panel_prov1, "respecto al 2019")) +
            xlab("Mes") + ylab("Exceso de muertes") 
          
          p3
        })
        
        output$Descargar_serie2_prov <- downloadHandler(
          filename = function() {
            
            if(input$prov_grafico == "Evolución del Covid-19"){
              paste0("Serie_covid_",input$panel_prov1,".png")
              
            }
            else if(input$prov_grafico == "Evolución de muertes"){
              paste0("Serie_muertes_",input$panel_prov1,".png")
              
            }else{
              paste0("Serie_exceso_",input$panel_prov1,".png")
              
            }
            
          },
          content = function(file) {
            device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
            
            if(input$prov_grafico == "Evolución del Covid-19"){
              ggsave(file, plot = plot_prov1(), device = device)
              
            }
            else if(input$prov_grafico == "Evolución de muertes"){
              ggsave(file, plot = plot_prov2(), device = device)
              
            }else{
              ggsave(file, plot = plot_prov3(), device = device)
              
            } 
            
          }
        )
        
        #Datos panel
        
        panel_prov1 <- reactive({
          mysubset_panel_prov1 <- subset( panel_provincia[ ,c(1:7)],
                                          panel_provincia$DEPARTAMENTO == input$panel_dep1 & panel_provincia$PROVINCIA == input$panel_prov1)
          
          mysubset_panel_prov1$ANO <- substr(mysubset_panel_prov1$FECHA,1,4)
          mysubset_panel_prov1$MES <- substr(mysubset_panel_prov1$FECHA,5,6)
          
          mysubset_panel_prov1 <- mysubset_panel_prov1[ ,c(1:3,9,8,5,6,7)]
          colnames(mysubset_panel_prov1) = c("Código", "Departamento", "Provincia", "Mes", "Año", "Casos", "Muertes Covid", "Muertes totales")
          mysubset_panel_prov1
        })
        
        output$data_panel_prov1 <- renderDataTable(
          panel_prov1(),
          options = list(pageLength = 15, lengthChange = FALSE,
                         initComplete = JS(
                           "function(settings, json) {",
                           "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                           "}"))
        )
        
        output$download_data_panel_prov1 <- downloadHandler(
          filename = function() {
            paste0("Datos_panel_", input$panel_prov1, ".csv")
          },
          content = function(file) {
            write.csv(panel_prov1(), file, row.names = FALSE)
          }
        )
        
        
        ##################################
        #Tab: Todas las provincias
        ################################## 
        
        #Datos acumulados
        
        stock_prov2 <- reactive({
          provincia_stock_prov2 <-  provincia[, c(1,3,4,2,6,8,10,7,9,11)]
          colnames(provincia_stock_prov2) = c("Código","Departamento", "Provincia", "Población", "Casos", "Muertes", "Muertes totales", "Contagios (%)", "Mortalidad (%)", "Muertes Covid (%)")
          provincia_stock_prov2
        })
        
        output$download_data_stock_prov2 <- downloadHandler(
          filename = function() {
            paste("Datos_stock_provincias.csv")
          },
          content = function(file) {
            write.csv(stock_prov2(), file, row.names = FALSE)
          }
        )
        
        output$data_stock_prov2 <- renderDataTable(
          stock_prov2(),
          options = list(pageLength = 15, lengthChange = FALSE,
                         initComplete = JS(
                           "function(settings, json) {",
                           "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                           "}"))
        )
        
        #Datos panel
        
        panel_prov2 <- reactive({
          datos_panel_prov2<- panel_provincia[ ,c(1:7)]
          
          datos_panel_prov2$ANO <- substr(datos_panel_prov2$FECHA,1,4)
          datos_panel_prov2$MES <- substr(datos_panel_prov2$FECHA,5,6)
          
          datos_panel_prov2 <- datos_panel_prov2[ ,c(1:3,9,8,5,6,7)]
          colnames(datos_panel_prov2) = c("Código", "Departamento", "Provincia", "Mes", "Año", "Casos", "Muertes Covid", "Muertes totales")
          datos_panel_prov2
        }) 
        
        
        output$download_data_panel_prov2 <- downloadHandler(
          filename = function() {
            paste("Datos_panel_provincias.csv")
          },
          content = function(file) {
            write.csv(panel_prov2(), file, row.names = FALSE)
          }
        )
        
        
        output$data_panel_prov2 <- renderDataTable(
          panel_prov2(),
          options = list(pageLength = 15, lengthChange = FALSE,
                         initComplete = JS(
                           "function(settings, json) {",
                           "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                           "}"))
        )
        
        
        ##################################
        #Tab: Distrito
        ##################################
        
        #Actualizar opciones para la serie de tiempo mensual-distrital
        observe({
                x <- input$panel_dep
                
                updateSelectizeInput(session, "panel_prov",
                                     label = 'Provincia:',
                                     choices = c( provincia$PROVINCIA[provincia$DEPARTAMENTO == x ])
                                     
                                     
                )
        })
        
        observe({
                y <- input$panel_prov
                
                updateSelectizeInput(session, "panel_dis",
                                     label = 'Distrito:',
                                     choices = c( distrito$DISTRITO[distrito$DEPARTAMENTO == input$panel_dep & distrito$PROVINCIA == y ])
                )
        })
        
        #Datos acumulados
        
        stock_dist1 <- reactive({
                distrito_stock_dist1 <- subset( distrito[, c(5,2,7,9,11,8,10,12)],
                                                distrito$DEPARTAMENTO == input$panel_dep & distrito$PROVINCIA == input$panel_prov & distrito$DISTRITO == input$panel_dis)
                colnames(distrito_stock_dist1 ) = c("Distrito", "Población", "Casos", "Muertes", "Muertes totales", "Contagios (%)", "Mortalidad (%)", "Muertes Covid (%)")
                distrito_stock_dist1 
        })
        
        output$data_stock_dis1 <- renderTable({
                stock_dist1() 
        })
        
        
        
        #Serie de tiempo
        
        #PARA VISUALIZAR
        #Tres series
        create_dygraph <- reactive({
                mysubset <- subset( panel_distrito,
                                    panel_distrito$DEPARTAMENTO == input$panel_dep & panel_distrito$PROVINCIA == input$panel_prov & panel_distrito$DISTRITO == input$panel_dis)
                
                b <- xts(x = mysubset[,c(6:8)] , order.by = mysubset$FECHA_)
                g <- dygraph(b, main = paste("Evolución del Covid-19 en el distrito de", input$panel_dis) ) %>%
                        dyAxis("y", label = "Número de personas") %>%
                        #dyAxis("x", label = "Fecha" ) %>%
                        dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
                        dySeries("CASOS", color = my_colors[3], label = "Casos Covid") %>%
                        dySeries("FALLECIDOS", color = "red", label = "Muertes Covid") %>%
                        dySeries("FALLECIDOS_SINADEF", color = my_colors[1], label = "Muertes totales") %>%
                        dyRangeSelector(dateWindow = c(input$year),height = 30) %>%
                        dyLegend(width = 150, labelsSeparateLines = TRUE)
                g
        })

        
        #Dos series
        create_dygraph1 <- reactive({
                mysubset1 <- subset( panel_distrito,
                                     panel_distrito$DEPARTAMENTO == input$panel_dep & panel_distrito$PROVINCIA == input$panel_prov & panel_distrito$DISTRITO == input$panel_dis)
                
                b1 <- xts(x = mysubset1[,c(7:8)] , order.by = mysubset1$FECHA_)
                g1 <- dygraph(b1, main = paste("Evolución de muertes en el distrito de", input$panel_dis) ) %>%
                        dyAxis("y", label = "Número de personas") %>%
                        #dyAxis("x", label = "Fecha" ) %>%
                        dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
                        dySeries("FALLECIDOS", color = "red", label = "Muertes Covid") %>%
                        dySeries("FALLECIDOS_SINADEF", color = my_colors[1],label = "Muertes totales") %>%
                        dyRangeSelector(dateWindow = c(input$year),height = 30) %>%
                        dyLegend(width = 150, labelsSeparateLines = TRUE)
                g1
        })
        
        
        #Exceso de muertes serie
        create_dygraph2 <- reactive({
          mysubset_dist2 <- subset( panel_distrito,
                                    panel_distrito$DEPARTAMENTO == input$panel_dep & panel_distrito$PROVINCIA == input$panel_prov & panel_distrito$DISTRITO == input$panel_dis)
          
          b_dist2 <- xts(x = mysubset_dist2[,10] , order.by = mysubset_dist2$FECHA_)
          g_dist2 <- dygraph(b_dist2, main = paste("Evolución de exceso de muertes en", input$panel_dis, "respecto al 2019") ) %>%
            dyAxis("y", label = "Exceso de muertes") %>%
            dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = TRUE, fillAlpha = 0.25, drawGrid = TRUE) %>%
            dySeries("V1", color = my_colors[2], label = "Exceso de muertes") %>%
            dyRangeSelector(dateWindow = c(input$year),height = 30) %>%
            dyLegend(width = 150, labelsSeparateLines = TRUE)
          g_dist2
        })
        
        output$serie_distrito  <- renderDygraph({
                
                if(input$dis_grafico == "Evolución del Covid-19"){
                        create_dygraph()
                  
                }
                else if(input$dis_grafico == "Evolución de muertes"){
                        create_dygraph1()
                }else{
                  create_dygraph2()
                }
                
        })
        
        
        #PARA DESCARGAR
        #Tres series
        plot_dis1 <- reactive({
          Data1 <- subset( panel_distrito,
                           panel_distrito$DEPARTAMENTO == input$panel_dep & panel_distrito$PROVINCIA == input$panel_prov & panel_distrito$DISTRITO == input$panel_dis)
          p <- ggplot(data=Data1) +
            theme_bw() +
            
            geom_point(mapping=aes(y=CASOS,x= FECHA_,color="Casos Covid"),size=2 ) +
            geom_line(mapping=aes(y=CASOS,x= FECHA_,color="Casos Covid"),size=1 ) +
            
            geom_point(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=1) +
            
            geom_point(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=1) +
            
            scale_color_manual(values = c(
              'Casos Covid' = my_colors[3] ,
              'Muertes Covid' = 'red',
              'Muertes totales'= my_colors[1] )) +
            labs(color = 'Series:') +
            scale_x_date(limit=c(input$year)) +
            ggtitle(paste("Evolución del Covid-19 en el distrito de", input$panel_dis)) +
            xlab("Mes") + ylab("Número de personas") 
          
          p
        })
        
        #Dos series
        plot_dis2 <- reactive({
          Data2 <- subset( panel_distrito,
                           panel_distrito$DEPARTAMENTO == input$panel_dep & panel_distrito$PROVINCIA == input$panel_prov & panel_distrito$DISTRITO == input$panel_dis)
          p2 <- ggplot(data=Data2) +
            theme_bw() +
            
            geom_point(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS,x= FECHA_,color="Muertes Covid"),size=1) +
            
            geom_point(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=2) +
            geom_line(mapping=aes(y=FALLECIDOS_SINADEF,x= FECHA_,color="Muertes totales"),size=1) +
            
            scale_color_manual(values = c(
              'Muertes Covid' = 'red',
              'Muertes totales'= my_colors[1] )) +
            labs(color = 'Series:') +
            scale_x_date(limit=c(input$year)) +
            ggtitle(paste("Evolución de muertes en el distrito de", input$panel_dis)) +
            xlab("Mes") + ylab("Número de personas") 
          
          p2
        })
        
        #exceso de muertes serie
        plot_dis3 <- reactive({
          Data3 <- subset( panel_distrito,
                           panel_distrito$DEPARTAMENTO == input$panel_dep & panel_distrito$PROVINCIA == input$panel_prov & panel_distrito$DISTRITO == input$panel_dis)
          p3 <- ggplot(data=Data3) +
            theme_bw() +
            
            geom_point(mapping=aes(y=EXCESO_MUERTES,x= FECHA_,color="Exceso de muertes"),size=2) +
            geom_line(mapping=aes(y=EXCESO_MUERTES,x= FECHA_,color="Exceso de muertes"),size=1) +
            
            scale_color_manual(values = c(
              'Exceso de muertes'= my_colors[2] )) +
            labs(color = 'Serie:') +
            scale_x_date(limit=c(input$year)) +
            ggtitle(paste("Evolución de exceso de muertes en",input$panel_dis, "respecto al 2019")) +
            xlab("Mes") + ylab("Exceso de muertes") 
          
          p3
        })
        
        output$Descargar_serie2 <- downloadHandler(
          filename = function() {
            
            if(input$dis_grafico == "Evolución del Covid-19"){
              paste0("Serie_covid_",input$panel_dis,".png")
              
            }
            else if(input$dis_grafico == "Evolución de muertes"){
              paste0("Serie_muertes_",input$panel_dis,".png")

            }else{
              paste0("Serie_exceso_",input$panel_dis,".png")
              
            }

          },
          content = function(file) {
            device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
            
            if(input$dis_grafico == "Evolución del Covid-19"){
              ggsave(file, plot = plot_dis1(), device = device)
              
            }
            else if(input$dis_grafico == "Evolución de muertes"){
              ggsave(file, plot = plot_dis2(), device = device)
              
            }else{
              ggsave(file, plot = plot_dis3(), device = device)
              
            } 
            
          }
        )
        
        #Datos panel
        
        panel_dist1 <- reactive({
                mysubset_panel_dist1 <- subset( panel_distrito[ ,c(1:8)],
                                                panel_distrito$DEPARTAMENTO == input$panel_dep & panel_distrito$PROVINCIA == input$panel_prov & panel_distrito$DISTRITO == input$panel_dis)
                
                mysubset_panel_dist1$ANO <- substr(mysubset_panel_dist1$FECHA,1,4)
                mysubset_panel_dist1$MES <- substr(mysubset_panel_dist1$FECHA,5,6)
                
                mysubset_panel_dist1 <- mysubset_panel_dist1[ ,c(1:4,10,9,6,7,8)]
                colnames(mysubset_panel_dist1) = c("Código", "Departamento", "Provincia", "Distrito", "Mes", "Año", "Casos", "Muertes Covid", "Muertes totales")
                mysubset_panel_dist1
        })
        
        output$data_panel_dis1 <- renderDataTable(
                panel_dist1(),
                options = list(pageLength = 15, lengthChange = FALSE,
                               initComplete = JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                                       "}"))
        )
        
        output$download_data_panel_dis1 <- downloadHandler(
                filename = function() {
                        paste0("Datos_panel_", input$panel_dis, ".csv")
                },
                content = function(file) {
                        write.csv(panel_dist1(), file, row.names = FALSE)
                }
        )
        
        
        
        ##################################
        #Tab: Todos los distritos
        ################################## 
        
        #Datos acumulados
        
        stock_dist2 <- reactive({
                distrito_stock_dist2 <-  distrito[, c(1,3,4,5,2,7,9,11,8,10,12)]
                colnames(distrito_stock_dist2) = c("Código","Departamento", "Provincia", "Distrito", "Población", "Casos", "Muertes", "Muertes totales", "Contagios (%)", "Mortalidad (%)", "Muertes Covid (%)")
                distrito_stock_dist2
        })
        
        output$download_data_stock_dis2 <- downloadHandler(
                filename = function() {
                        paste("Datos_stock_distritos.csv")
                },
                content = function(file) {
                        write.csv(stock_dist2(), file, row.names = FALSE)
                }
        )
        
        output$data_stock_dis2 <- renderDataTable(
                stock_dist2(),
                options = list(pageLength = 15, lengthChange = FALSE,
                               initComplete = JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                                       "}"))
        )
        
        #Datos panel
        
        panel_dist2 <- reactive({
                datos_panel_dist2<- panel_distrito[ ,c(1:8)]
                
                datos_panel_dist2$ANO <- substr(datos_panel_dist2$FECHA,1,4)
                datos_panel_dist2$MES <- substr(datos_panel_dist2$FECHA,5,6)
                
                datos_panel_dist2 <- datos_panel_dist2[ ,c(1:4,10,9,6,7,8)]
                colnames(datos_panel_dist2) = c("Código", "Departamento", "Provincia", "Distrito", "Mes", "Año", "Casos", "Muertes Covid", "Muertes totales")
                datos_panel_dist2
        }) 
        
        
        output$download_data_panel_dis2 <- downloadHandler(
                filename = function() {
                        paste("Datos_panel_distritos.csv")
                },
                content = function(file) {
                        write.csv(panel_dist2(), file, row.names = FALSE)
                }
        )
        
        
        output$data_panel_dis2 <- renderDataTable(
                panel_dist2(),
                options = list(pageLength = 15, lengthChange = FALSE,
                               initComplete = JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': '#d65a5a', 'color': '#fff' });",
                                       "}"))
        )
        
        
}


shinyApp(ui = ui, server = server)