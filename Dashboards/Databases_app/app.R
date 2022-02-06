library(shiny)
library(shinydashboard)
library(haven)

###############################################################################
#IMPORTAMOS DATOS
###############################################################################

#setwd("C:/Q_lab/R_shiny/QLAB-Big Data")
#COVID
covid_nac<- read.csv("COVID_nacional_panel.csv")
covid_dep<- read.csv("COVID_departamento_panel.csv")
covid_prov<- read.csv("COVID_provincia_panel.csv")
covid_dist<- read.csv("COVID_distrito_panel.csv")


#SIAF
#Gastos
#for (i in 2007:2016){
 # SiafG <- read_dta( paste0("gastos", i , "a.dta") )
  #assign(paste("gastos", i, sep = ""), SiafG)

#}

#HEADER
header <- dashboardHeader(title = "QLAB-DATOS")

#SIDEBAR
sidebar <- dashboardSidebar(width = 280,
        sidebarMenu(
                menuItem("Información general", tabName = "info", icon=icon("home")),
                menuItem("Bases creadas y/o procesadas por QLAB", tabName = "qlab_data", icon = icon("th")),
                menuItem("Enlaces a otras Fuentes en Línea", tabName = "online_data", icon = icon("th"))
        ) 
)

#BODY
body <- dashboardBody(
        tags$head(tags$style(HTML('
                      .main-header .logo {
                        font-family: "Georgia", Times, "Times New Roman", serif;
                        font-weight: bold;
                        font-size: 24px;
                      }
                    '))),
        
        #Estilo de los tabBox
        tags$style(".nav-tabs {
                                background-color: transparent;   
                                font-family:Georgia;
                                }
                                                
                                .nav-tabs-custom .nav-tabs li.active:hover a, .nav-tabs-custom .nav-tabs li.active a {
                                background-color: #F2F1F1;
                                border-color: transparent;
                                }
                                                
                                .nav-tabs-custom .nav-tabs li.active {
                                border-top-color: red;
                                }"),
        
        #Estilo de los Box
        tags$style(HTML("

                    .box.box-solid.box-primary{
                    border-bottom-color:transparent;
                    border-left-color:transparent;
                    border-right-color:transparent;
                    border-top-color:transparent;
                    background:#F2F1F1
                    }

                    ")),
        
        tabItems(
                # Información general
                tabItem(tabName = "info", 
                        
                        fluidRow(
                                column(12, br(),br(),
                                         box( status = "danger", solidHeader = FALSE,
                                            height = "300px",  width = 12, 
                                            
                                            p(br(),"¡¡Bienvenidos!!", br(),br(),
                                             "La Facultad de Ciencias Sociales, a través de su Laboratorio de Inteligencia Artificial y Métodos Computacionales, Q-LAB, pone a disposición de estudiantes, profesionales egresados, y a la sociedad civil su repositorio de datos QLAB-DATOS. 
                                             Este repositorio contiene principalmente información socioeconómica de la realidad peruana. El repositorio tiene dos recursos principales. 
                                             El primero es un centro de referencia a fuentes originales de datos en temas diversos como salud, educación, empleo, industria, finanzas públicas, etc. 
                                             El segundo recurso consiste en datos originales o con algún nivel de procesamiento hecho por el equipo de QLAB que no es posible encontrar en otros sitios de referencia.
                                             Con QLAB-DATOS, la Facultad de Ciencias Sociales busca contribuir al desarrollo de investigaciones y análisis que contribuyan a la propuesta de políticas basadas en evidencia."
                                             , style = "text-align:justify; color: #14505B ; font-size: 18px")
                                       )
                                       ),
                                
                                column(12,
                                       br(),br(),br(),br(),br(), br(), br(),br(),br(),
                                       p(br(),tags$img(src="pucp-qlab.png",width="320px",height="60px"), style="text-align:right")      
                                )
                        )
                ),
                ####################
                # Datos QLAB
                ####################
                tabItem(tabName = "qlab_data",
                        
                        fluidRow(
                          
                          tabBox(
                            #title = "Datos QLAB",
                            id = "qlab_tabset1", width = 12, height = "650px",
                            
                            #SALUD        
                            tabPanel("Salud", icon = icon("briefcase-medical"),
                                     
                                     fluidRow( 
                                       br(),
                                       
                                       #COVID-19
                                       box(em(strong("Covid-19")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                           style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                           
                                           fluidRow(
                                             column(9,
                                                    br(),
                                                    p("Bases de datos sobre la evolución de la pandemia en el Perú"
                                                      , style = "text-align:justify; color: #4C4C4C ; font-size: 16px")
                                             ),
                                             
                                             column(
                                               tags$img(src="covid19_.png",width="80px",height="90px")
                                               ,width=3,style="text-align:center"),
                                             
                                           ),
                                           
                                           fluidRow(
                                             column(12,
                                                    br(),
                                                    
                                                    radioButtons(inputId="qlab_covid",label="Elige la base que desees descargar:",
                                                                 choices=c("Panel mensual a nivel nacional", "Panel mensual a nivel departamental", "Panel mensual a nivel provincial", "Panel mensual a nivel distrital")),
                                                    
                                                    br(),
                                                    tags$head(
                                                      tags$style(HTML('#db_qlab_covid{color:black;background-color:white;border-color:#807e7e}'))
                                                    ),
                                                    downloadButton("db_qlab_covid", "Descargar.csv")

                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"
                                                    
                                             ),
                                             
                                             column(12, 
                                                    br(),
                                                    p(
                                                      "_____________________",br(),
                                                      strong("Sobre las variables:"), br(),br(), 
                                                      strong("Casos:"),"Positivos a la Covid-19 (MINSA)", br(),
                                                      strong("Fallecidos:"),"Muertos por la Covid-19 (MINSA)", br(),
                                                      strong("Fallecidos:"),"Sinadef: Muertos independientemente de la causa"),
                                                    
                                                    p(br(),
                                                      "Para mayor información ver",strong(tags$a(href="https://qlab-pucp.shinyapps.io/PeruCovid/","aquí", target="_blank", style="color:#262626; text-decoration: underline")))
                                                    
                                                   ,style = "text-align:left; color:#4C4C4C; font-size: 13px"
                                                   
                                           )
                                           
                                       )
                                     )
                                  )  
                            ),
                            
                            #CUENTAS FISCALES        
                            tabPanel("Cuentas fiscales", icon = icon("hand-holding-usd"),
                                     
                                     fluidRow( 
                                       br(),
                                       
                                       #SIAF-GASTO
                                       box(em(strong("Información de Gastos - SIAF")), width = 6, height = "1360px", status = "primary", solidHeader = TRUE, 
                                           style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 26px; padding-top: 20px",
                                           
                                           fluidRow(
                                             column(12,
                                                    br(),
                                                    #SIN PROCESAR
                                                    p(strong("Bases fuentes"),
                                                      style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                    
                                                    p("Bases sin procesar que cuentan con información de todos los distritos sobre el
                                                     Presupuesto Institucional de Apertura (PIA), el Presupuesto Institucional Modificado (PIM), y la ejecución del gasto en las fases de Compromiso, Devengado y Girado.
                                                     Otras de las variables con las que se cuentan son la composición del gasto según genérica, categoría presupuestaria y fuente de financimiento.
                                                     Estas bases son usadas para generar las bases procesadas.",
                                                      style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                    
                                                    #a nivel local
                                                    p(br(),strong(em("Gobiernos locales")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases a nivel local en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1oy3olvXWmAAjv1V5YkeWIiOCfCGOfTG-?usp=sharing","2007,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1KArkMIniUDL4bkA5nu_gGHqwndics3Po?usp=sharing","2008, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1NrXqGmiteN3auWe-cM43STSW7Ieol50A?usp=sharing","2009, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1h__lpOI0qppFrxOYRY-mAIRDSz6rbm78?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1q1USBVN8iw_0F_ltqXNheclP-n_TaQdP?usp=sharing","2011, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1iHQ2mgS9Jgf-F6QGQDo7DfAITgV_RPyb?usp=sharing","2012, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Mff8uWJJuQ0uL9DXtN9rzYozlTK9Zt94?usp=sharing","2013, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1610iiq-wWaf2psHX22_pCPDOgt9eL7dq?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1YsL8qOdLusYTv1QCvME7e9GRuQvpJF9V?usp=sharing","2015, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1TccJAqVOUydX_mm3hOaAuvHTXH85LDWO?usp=sharing","2016, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1PVrZpaYoc2akx63apkppuo5P93NuLXyt?usp=sharing","2017, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1GjSVDwcFHC45XfuTOWiCRXhOLXAq7MUa?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    #a nivel regional
                                                    p(br(),strong(em("Gobiernos regionales")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases a nivel regional en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Ok1OeuUHLhjwqnxWToKnco-OrGUtpp83?usp=sharing","2009, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1VHx-tKvwSjXLp11D5xV4BUdMc2zFuiJP?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1ZxqWDOgpn21wcHz1PMLvXDUk3usvyZXg?usp=sharing","2011, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1GwDt7oilNREHGDASDfez_ZkZqjWLdw2B?usp=sharing","2012, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1QV3XKEQ0--xOv3MsHP3th941Z2mBA1fJ?usp=sharing","2013, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1rRRrx7K9scvr5hEGNAQ4DeRiIdgIgRJQ?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1TZHIUHPNzfKGBATYA5h-g3TxNuHwH5VQ?usp=sharing","2015, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1DfnLhU5e7c00G9lKv8_jXTpehxJAnxX4?usp=sharing","2016, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1sTU6eHAEi7qPv6EkTJJOSJUSDOLazvGb?usp=sharing","2017, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1NpYvr062faZU9v_fjROFOhYrViuJ-FV6?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),

                                                    #PROCESADAS
                                                    p(br(),
                                                      strong("Bases procesadas"),
                                                      style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                    
                                                    p("Bases de datos con información desagregada a nivel distrital sobre el PIA, el PIM, el total ejecutado, el total devengado y dos variables que
                                                    miden la eficiencia del gasto en base al porcentaje utilizado del presupuesto asignado.
                                                     ",
                                                      style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                    
                                                    #a nivel local
                                                    p(br(),strong(em("Gobiernos locales")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases a nivel local en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/14HejS4pMWwwNaYuQdHr8fY9ofAvpaVvX?usp=sharing","2007,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1y_KxfBsUPZ6Bd86h3ZM2_BC5EFkva7Ac?usp=sharing","2008, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1dYJbTkCgbFJjStmSnmAfD8oGWp1z-pqT?usp=sharing","2009, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1NBo7V5xUQdZ0xmi8-0dFlUKCq_Phw0xs?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1RNgFR9IxsQztEFiBmRtel8YXCT2VwQ0A?usp=sharing","2011, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/12ifDPCKO30TL_hDyGbki8Mejuu6Q28_O?usp=sharing","2012, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/10Q4_FKqKZR-4YGz9hKlSBXFZG8Q7G8-c?usp=sharing","2013, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1regBlNKd86NUsV-seIYs4kadlSoxRxbI?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1P3Bopj857QWfXUgI5TQfEJlnfZKevLmE?usp=sharing","2015, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1RJY1NkWMIylZzeOdnP2Xm3AguB0iy83z?usp=sharing","2016, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1GCDo_nzIR5Gx4NReWKOIITys3nBBEsTv?usp=sharing","2017, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1ACbOlUGUNFzfa1XalFGuzHYSzVWEe1g-?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    #a nivel regional
                                                    p(br(),strong(em("Gobiernos regionales")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases a nivel regional en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1AX5G3j2-P7N4BpQ74teEntKOrtJCIWev?usp=sharing","2009, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/16SXDXtjwyauJHgdDkE1I8JDPH6SrIC3z?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1fvRzwCyw1wXrbY6WMT7Xa7QHayNFpQ1W?usp=sharing","2011, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1BgXYu8R6FtCjWccV1dvVlaOMwHMPJ8k7?usp=sharing","2012, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1GY0gJ7nw6IXGhvk6Hdg0j9LQrANC6tHT?usp=sharing","2013, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1WkQQYxg2MowHAJNtVMo3xr70_WwTqI3Q?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Qpioq_yzH8Ahxi5XLKZYCoQagonCePhO?usp=sharing","2015, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/16-wFdTuWd9fTWlmOfdv1i20R5Ei2APTE?usp=sharing","2016, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1gVZY1PkGZ6_9ikUgTpfVR8tzsfAcA6XG?usp=sharing","2017, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1aO0ZZALYFt1NLUbr62fm-lRqUsGsTd0n?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    p(br(),
                                                      "_____________________",br(),
                                                      strong("Sobre las variables:"), br(),br(),
                                                      strong("Expenditurefic1:"),"Total ejecutado/PIM", br(),
                                                      strong("Expenditurefic2:"), "Total devengado/PIM", br(),
                                                      style = "text-align:left; color:#4C4C4C; font-size: 13px" ),
                                                    
                                                    
                                             )
                                          )
                                       ),
                                       
                                       #SIAF-INGRESO
                                       box(em(strong("Información de Ingresos - SIAF")), width = 6, height = "1360px", status = "primary", solidHeader = TRUE, 
                                           style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 26px; padding-top: 20px",
                                           
                                           fluidRow(
                                             column(12,
                                                    br(),
                                                    #SIN PROCESAR
                                                    p(strong("Bases fuentes"),
                                                      style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                    
                                                    p("Bases sin procesar que cuentan con información de todos los pliegos presupuestarios sobre el 
                                                     Presupuesto Institucional de Apertura (PIA), el Presupuesto Institucional Modificado (PIM), el total recaudado, 
                                                     y la composición del ingreso según rubro, genérica y fuente de financimiento.
                                                     Estas bases son usadas para generar las bases procesadas.",
                                                      style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                    
                                                    #a nivel local
                                                    p(br(),strong(em("Gobiernos locales")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases a nivel local en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/10XvO9Nflr3bNaJqeVi4F4CBCSKj3XqXw?usp=sharing","2009, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1ZDYBTrcjH65kXnaNnp_oYkjFv6QBlN1n?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1QLfcWpBAdaJa6Zqm5dn2KHT6F9TSfJil?usp=sharing","2011, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1-wF--bSoIc4Tm44ZoN0N1mQbO0ZE0A_n?usp=sharing","2012, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1aOl2nG9dkgBTquzim1QruQJcb13W0068?usp=sharing","2013, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/11mRGDhPZleSCsO0onlBKHpfExmBQ_Al2?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/19FWAmYJqbyMV7GFRkT3aVoxmsX9PvqLb?usp=sharing","2015, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1mUT1RqoKx6cG6mD7j3nFzrAVI-RMrtgc?usp=sharing","2016, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/14nsAxRUW01LP2SNyphD_0HD9Iy6vIsQG?usp=sharing","2017, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1G-M_o4GoEj4Gf0dmhf64AVnG5UnVgtHW?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    #a nivel regional
                                                    p(br(),strong(em("Gobiernos regionales")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases a nivel regional en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Ai3QMr4ipeJNyD7Bf7b8NfdNB6AaePzx?usp=sharing","2009, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1qOf7DGloabsvm0C1IDipn3tlMJpAEkMT?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1X-OkUzTboHoM_tYeVLt11-HErsU6TI9C?usp=sharing","2011, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1vODxzrvZK04DeH5OlheHVtrQi40HYniQ?usp=sharing","2012, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1MNOy9yXa52a4Eqc8D3gZvzhkLzzXQ5bK?usp=sharing","2013, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1P8lpo6D_HOnALEJT-MsVWCif0yQLY4pq?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1xaSV-RZMDOsh4OFJyUIrTLV2yaXYEAYS?usp=sharing","2015, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1bSHQX4Ym7SDbcOo0eQqHWh7tGo0prVCD?usp=sharing","2016, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1kUN4GdBPsRaVDazuNXeVwXnUj05rXCfI?usp=sharing","2017, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1e4DulHBJ5-WcsR_G9K4g2Aya6hRece3z?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),

                                                    #PROCESADAS
                                                    p(br(),
                                                      strong("Bases procesadas"),
                                                      style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                    
                                                    p("Bases de datos con información desagregada a nivel de pliego presupuestal sobre el PIA, el PIM, y el total recaudado según rubro y específica determinada.
                                                     ",
                                                      style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                    
                                                    #a nivel local
                                                    p(br(),strong(em("Gobiernos locales")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases a nivel local en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1a9V1_mD6UzHaMkgQ_ECLMptfHQsaUiB8?usp=sharing","2009, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Bsa--VDjh747-oGds3WqUo7_A2BR85F_?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1U-_0dijcfRkSFfzGWp7HOEH6Z8TqTqjP?usp=sharing","2011, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1fQxj8X39Gn8nUCzx1L_GbwLYsyfT7Phe?usp=sharing","2012, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1VXrntLG4xOfMf9teY4oX8MtlY3CnPohw?usp=sharing","2013, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/157k_fszDEl_fHHzeAOb0m5vKT_lW5J1L?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1bFnUA447p4bWh7QDQqat3XTIGi4dZMES?usp=sharing","2015, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1qseTxL3ppV4xJpjtnH-ur9XyhQo7h0Aw?usp=sharing","2016, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Ey1koBiEXksv8jYwU9-CumoyLqneOLy4?usp=sharing","2017, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1ypwcGL2QI6O3OsZfs6KUxMMbOunoAfUo?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),

                                                      br(),br(),"Formato: DTA"
                                                      
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    #a nivel regional
                                                    p(br(),strong(em("Gobiernos regionales")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases a nivel regional en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1lSBxAh1Q_rPcPAqj5bnhbpiQ3aZP2RaR?usp=sharing","2009, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/14ZgUdjMYIQd1CFpsZWn76XX3i43LyLaw?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1obDpnbkVpy4eX7PL8NArT6ZUDxCjex4B?usp=sharing","2011, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1wDEk0TvwHul18hmeuRXEI8kCmdYiwQ22?usp=sharing","2012, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Th4G5sEqNMGZpMulmmskLU5mmqxMicET?usp=sharing","2013, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1_Hd_Ox-Q7_38v9-5ADy77KMjwMmbg132?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1fsVjD2f0V4kQdXEyEGwKhRZExFsJFRnn?usp=sharing","2015, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1e0iMO3JhPyhnG9kBExoaxm5gj8yK3wws?usp=sharing","2016, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1M3Xw1INCCxFNW19VaZA8txHfgZw1SCte?usp=sharing","2017, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1qjU2juPRcKSBsKQBURIZeLNo9bT062jq?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
   
                                                    p(br(),
                                                      "_____________________",br(),
                                                      strong("Sobre las variables:"), br(),br(),
                                                      strong("piatotalrevenue:"),"PIA total" ,br(),
                                                      strong("pimtotalrevenue:"),"PIM total" ,br(),
                                                      strong("totalrevenue:"),"Total recaudado" ,br(),
                                                      strong("piacollected:"), "PIA total si es que el rubro es por impuestos municipales o recursos directamente recaudados", br(),
                                                      strong("pimcollected:"), "PIM total si es que el rubro es por impuestos municipales o recursos directamente recaudados", br(),
                                                      strong("collectrev:"), "Total recaudado si es que el rubro es por impuestos municipales o recursos directamente recaudados" ,br(),
                                                      strong("piafoncomun1:"), "PIA total si es que el rubro es por el fondo de compensación municipal", br(),
                                                      strong("pimfoncomun1:"), "PIM total si es que el rubro es por el fondo de compensación municipal", br(),
                                                      strong("foncomun1:"), "Total recaudado si es que el rubro es por el fondo de compensación municipal", br(),
                                                      strong("piafoncomun2:"), "PIA total si es que la específica determinada es por el fondo de compensación municipal", br(),
                                                      strong("pimfoncomun2:"), "PIM total si es que la específica determinada es por el fondo de compensación municipal", br(),
                                                      strong("foncomun2:"), "Total recaudado si es que la específica determinada es por el fondo de compensación municipal", br(),
                                                      strong("canonmineropia:"),"PIA total si es que la específica determinada es por el canon minero", br(),
                                                      strong("canonmineropim:"),"PIM total si es que la específica determinada es por el canon minero", br(),
                                                      strong("canonminero:"),"Total recaudado si es que la específica determinada es por el canon minero", br(),
                                                      style = "text-align:left; color:#4C4C4C; font-size: 13px" ),
                                                    
                                             )

                                           )
                                       ),
                                       
                                       #CORREO
                                       box( width = 6, height = "40px", status = "primary", solidHeader = TRUE, 
                                          p("Consultas a", strong("qlab_csociales@pucp.edu.pe"),
                                            style = "font-family: Georgia;text-align:left;color:black ;font-size: 13px"),
                                          )
                                       
                                     ),
                                     
                                     ),
                            
                            #ELECCIONES    
                            tabPanel("Elecciones", icon = icon("vote-yea"),
                                     
                                     fluidRow(
                                     br(),
                                     #ELECCIONES-Infogob
                                     box(em(strong("Información sobre Elecciones - Infogob")), width = 6, height = "1380px", status = "primary", solidHeader = TRUE, 
                                         style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 26px; padding-top: 20px",
                                         
                                         fluidRow(
                                           column(12,
                                                  br(),
                                                  #SIN PROCESAR
                                                  p(strong("Bases fuentes"),
                                                    style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                  
                                                  p("Bases sin procesar que cuentan con información sobre las elecciones regionales, municipales provinciales y municipales distritales por años.
                                                  En específico, se dispone de información desagregada por region, provincia y distrito sobre el número de electores, y la cantidad de votos a favor de 
                                                  cada organización política. Estas bases son usadas para generar las bases procesadas.",
                                                    
                                                    style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                  
                                                  #Elecciones regionales
                                                  p(br(),strong(em("Elecciones regionales")),
                                                    style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                  
                                                  p("Puede descargar las bases de las elecciones regionales en los siguientes enlaces:", br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1uIfPVn08dVOHSIlA7pQjjV9cM5EFeRh3?usp=sharing","2002,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1EOfidG60gcjv123kSJvjpSRGqqp4qajt?usp=sharing","2006, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1JWjg-_9vgrr_fZxClmXZi9A5GTJFuofk?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1NVuX6KZPuiVQ0stJTWy6a-3yEnf96Gfd?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1YIzvCrxEelxYZz1uIw0_Sc4MM-5DnzuU?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    
                                                    br(),br(),"Formato: DTA"
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                  
                                                  #Elecciones provinciales
                                                  p(br(),strong(em("Elecciones municipales provinciales")),
                                                    style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                  
                                                  p("Puede descargar las bases de las elecciones provinciales en los siguientes enlaces:", br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1OddcoD2lmrj6Lqd1ANRIi5GUR57sVLcv?usp=sharing","2002,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/14Xl_sbl3IuIMuGnlR9Ut4Dwl0PWUrZWc?usp=sharing","2006, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1MFPPORegXp33Rrigk_BupBa0rGYpeqrv?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1jk_480Bs3yc0YbXxyWPSgB9_504sVFFD?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1YzsCBFpeU97yIgmZnnQkZl7osYNCSdYC?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),

                                                    br(),br(),"Formato: DTA"
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                  
                                                  #Elecciones distritales
                                                  p(br(),strong(em("Elecciones municipales distritales")),
                                                    style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                  
                                                  p("Puede descargar las bases de las elecciones distritales en los siguientes enlaces:", br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1QODpFOXn5wHH_TTjaf378vCMGr-vM4D7?usp=sharing","2002,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/14hSNEQGpPd2XeBgvbzJYxbJbq6shFiX1?usp=sharing","2006, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/10B5H7vX0kSYYLqBF-DhCF64PYdifYf07?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1hb1Q-DXNehNMF49An_epXIrIzwaXE61g?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1fBr5Z5wJ66f7A5iz9rYL5HnyqkGodjHH?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    
                                                    br(),br(),"Formato: DTA"
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                  
                                                  #PROCESADAS
                                                  p(br(),
                                                    strong("Bases procesadas"),
                                                    style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                  
                                                  p("Bases procesadas que cuentan con información desagregada a nivel regional, provincial y distrital sobre el porcentaje de participación, el porcentaje de votos del ganador 
                                                  y el margen de victoria de los distintos tipos de elecciones (regionales, municipales provinciales y municipales distritales) por años.
                                                     ",
                                                    style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                  
                                                  #Elecciones regionales
                                                  p(br(),strong(em("Elecciones regionales")),
                                                    style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                  
                                                  p("Puede descargar las bases de las elecciones regionales en los siguientes enlaces:", br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1mzlZHex63aD0rzX6ahdH4zzgCCHfkAep?usp=sharing","2002,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1_g1A0Sda-qcsTbasoZM4Paz964OybWGJ?usp=sharing","2006, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1r4AZE0A88msBm1ddZQMnE4jUaTjEOAmU?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1SB0oNCBJtUajbEH-H3XtbFCmtPBTIJnp?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1JafHIFzMpWuQYD_DmKYehXuw2R_KkLMr?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    
                                                    br(),br(),"Formato: DTA"
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                  
                                                  #Elecciones provinciales
                                                  p(br(),strong(em("Elecciones municipales provinciales")),
                                                    style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                  
                                                  p("Puede descargar las bases de las elecciones provinciales en los siguientes enlaces:", br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1lThvvg7au5_Fnpk8uGAE6_h-1aJwsbee?usp=sharing","2002,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1Fi6nXmtAnJS-nEzC2atmpuNWJXI667Pe?usp=sharing","2006, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1zDyY7j3lvwMehJlOh4ydNV-G_Czyh5lO?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1QQHRnOiwr3g69UqBnS1VnaN1MhMOi55n?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1OtH3NqnW-1gTDsnC6O4G4HHdQz9t61lU?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    
                                                    br(),br(),"Formato: DTA"
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                  
                                                  #Elecciones distritales
                                                  p(br(),strong(em("Elecciones municipales distritales")),
                                                    style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                  
                                                  p("Puede descargar las bases de las elecciones distritales en los siguientes enlaces:", br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1LxknHgCjQVsYgVOjvmvn6qPflB_uCF0x?usp=sharing","2002,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1_-2hK4iL_FZ1pkw2g4hADuA61t0_sXnb?usp=sharing","2006, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1EtzSli4WSgeWTwbaJjVPTARBbs9z4ctQ?usp=sharing","2010, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1QNZT4ZxgTtKHeKvqOzBUmoboIqVrouDc?usp=sharing","2014, ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1bAKpbXWj_L57vDXbevx7_yco5cSq0yMp?usp=sharing","2018 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    
                                                    br(),br(),"Formato: DTA"
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                  
                                                  p(br(),
                                                    "_____________________",br(),
                                                    strong("Sobre las variables:"), br(),br(),
                                                    strong("Votos %:"),"El porcentaje de participación (Votos emitidos/Total de electores)", br(),
                                                    strong("Votos ganador %:"), "El porcentaje de votos del ganador", br(),
                                                    strong("Votos segundo %:"), "El porcentaje de votos del segundo lugar", br(),
                                                    strong("Margvictoria %:"), "Votos ganador % - Votos segundo %", br(),
                                                    style = "text-align:left; color:#4C4C4C; font-size: 13px" ),

                                           )
                                         )
                                     ),
                                     
                                     #Autoridades reelectas
                                     box(em(strong("Autoridades Reelectas - Infogob")), width = 6, height = "1380px", status = "primary", solidHeader = TRUE, 
                                         style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 26px; padding-top: 20px",
                                         
                                         fluidRow(
                                           column(12,
                                                  br(),
                                                  #BASES FUENTES
                                                  p(strong("Bases fuentes"),
                                                    style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                  
                                                  p("Bases que cuentan con información sobre las autoridades electas y reelectas en las elecciones municipales provinciales 
                                                  y distritales. En específico, se cuenta con los nombres y apellidos, el cargo (Alcalde o Regidor) y el sexo de las autoridades. 
                                                  También se dispone de información sobre la organización política y el tipo de organización política al que pertenecen las autoridades.
                                                 Estas bases son usadas para generar las bases procesadas.",
                                                    style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                  
                                                  #Elecciones municipales provinciales
                                                  p(br(),strong(em("Elecciones municipales provinciales")),
                                                    style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                  
                                                  p("Puede descargar las bases de las autoridades provinciales en los siguientes enlaces:", br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1Hq1C5QmPtcsBGy2LFGobHSPveb8Wfw3F?usp=sharing","1998-2002,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1cui6klaRedwlsyD9nLhU9FX5silj_yJ1?usp=sharing","  2002-2006,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1fGFh6SSx3Rl7a0wefzlYE5Pbh_bAEZjg?usp=sharing","  2006-2010,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/17nJmzoI62SAk4CbXKFijYfr8UMApgNP1?usp=sharing","  2010-2014,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1L2tIQzAefdOSrTjk9m9-WlYqWmmZ1bu1?usp=sharing","  2014-2018", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    
                                                    br(),br(),"Formato: DTA"
                                                    
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                  
                                                  #Elecciones municipales distritales
                                                  p(br(),strong(em("Elecciones municipales distritales")),
                                                    style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                  
                                                  p("Puede descargar las bases de las autoridades distritales en los siguientes enlaces:", br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1XFfoOKmmZcNijMfGs1Q1A4WyUJxD1Ole?usp=sharing","1998-2002,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1tEKik-G4-WJ5ICwZwk9Cf-tUylKpKwFZ?usp=sharing","  2002-2006,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1J-ESzxst5veXEM_fh_uc2cEPizc6y3v_?usp=sharing","  2006-2010,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1Twb0ehDfoRJ_6yy85XgfGWGNpbnUzuj7?usp=sharing","  2010-2014,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1LtKy4C_4xPgNzbr0MzN7_9OsJymf_3Ci?usp=sharing","  2014-2018", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    
                                                    br(),br(),"Formato: DTA"
                                                    
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                  
                                                  p(br(),
                                                    "_____________________",br(),
                                                    strong("Sobre las variables:"), br(),br(),
                                                    strong("reelecto:"),"Variable dummy que es 1 cuando la autoridad fue reelegida y 0 cuando no lo es" ,br(),
                                                    style = "text-align:left; color:#4C4C4C; font-size: 13px" ),
                                                  
                                                  #PROCESADAS
                                                  p(br(),
                                                    strong("Bases procesadas"),
                                                    style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                  
                                                  p("Bases panel anual para el periodo 2003-2018 que cuentan con información sobre si el alcalde distrital o provincial es reelecto. 
                                                  Estos paneles no consideran si es que hubo revocatoria. Es decir, no consideran si el alcalde fue revocado antes de acabar su periodo de mandato.
                                                     ",
                                                    style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                  
                                                  
                                                  p(br(),"Puede descargar las base panel en los siguientes enlaces:", br(),br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1vM0KfdLCilkzU5dNjoPl8bz5uOUp2FB6?usp=sharing","Alcaldes provinciales reelectos", target="_blank", style="color:#262626; text-decoration: underline")),br(),br(),
                                                    strong(tags$a(href="https://drive.google.com/drive/folders/1QVRjP5wQBmqzxWWA71KRlg2i2gIdKam2?usp=sharing","Alcaldes distritales reelectos", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    
                                                    br(),br(),"Formato: DTA"
                                                    
                                                    , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                  
                                                  
                                                  p(br(),
                                                    "_____________________",br(),
                                                    strong("Sobre las variables:"), br(),br(),
                                                    strong("reelecto:"),"Variable dummy que es 1 cuando el alcalde (distrital o provincial) es reelegido y 0 cuando no lo es en un año determinado" ,br(),
                                                    style = "text-align:left; color:#4C4C4C; font-size: 13px" ),
                                                  
                                           )
                                           
                                         )
                                     )
                                       
                                     ),
                                     
                                     fluidRow(
                                       
                                       #CORREO
                                       box( width = 6, height = "40px", status = "primary", solidHeader = TRUE, 
                                            p("Consultas a", strong("qlab_csociales@pucp.edu.pe"),
                                              style = "font-family: Georgia;text-align:left;color:black ;font-size: 13px"),
                                       )
                                     )
                                    ),
                            
                            #ENERGÍA Y MINAS   
                            tabPanel("Energía y Minas", icon = icon("industry"),
                                     
                                     fluidRow(
                                       br(),
                                       #MINEROS - VALOR PRODUCIDO
                                       box(em(strong("Mineros - Valor producido")), width = 6, height = "1465px", status = "primary", solidHeader = TRUE, 
                                           style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 26px; padding-top: 20px",
                                           
                                           fluidRow(
                                             column(12,
                                                    br(),
                                                    #SIN PROCESAR
                                                    p(strong("Bases fuentes"),
                                                      style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                    
                                                    p("Se utilizaron dos bases fuentes. Por un lado, se usaron los", strong(tags$a(href="http://www.minem.gob.pe/_estadisticaSector.php?idSector=1&idCategoria=10","reportes de la producción minera anual", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    "del Ministerio de Energía y Minas (MINEM). Estos cuentan con información sobre las unidades mineras, su ubicación (región, provincia y distrito), y su producción total mensual. Por otro lado, se utilizaron"
                                                    ,strong(tags$a(href="https://estadisticas.bcrp.gob.pe/estadisticas/series/mensuales/exportaciones-de-productos-tradicionales-precios-m","las series mensuales de los precios mineros", target="_blank", style="color:#262626; text-decoration: underline")),
                                                    "del Banco Central de Reserva del Perú (BCRP). Estas bases son usadas para generar las bases procesadas.",
                                                      
                                                      style = "text-align:justify; color:#4C4C4C; font-size: 14px"),

                                                    
                                                    #PROCESADAS
                                                    p(br(),
                                                      strong("Bases procesadas"),
                                                      style = "text-align:left;color:#14505B ;font-size: 18px;text-decoration: underline"),
                                                    
                                                    p("Bases panel a nivel distrital que cuentan con información mensual sobre la producción, el precio y el valor aproximado producido del cobre, oro, plata, zinc, plomo y hierro, los cuales 
                                                    representan los principales minerales de exportación del país.
                                                     Tanto los precios como la producción han sido homogeneizados en la misma unidad para poder hallar el valor de producción aproximado. Es importante señalar que el valor producido es
                                                     aproximado, ya que se utilizaron como precios las series del BCRP, las cuales no muestran la diferencia de precios para metales concentrados o refinados. 
                                                      ",
                                                      style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                    
                                                    #Cobre
                                                    p(br(),strong(em("Cobre - Valor aproximado producido (¢US$ por libras)")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases panel en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Rj5tfag3q8fIjQCo1slay6aSgHMR6stG?usp=sharing","2006,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1C7WJqiAqqEcmedGseDBDtMLiTeOHEsTQ?usp=sharing","2007,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1qhvMXA4e8YD8nkzmezXHCT9KC4A-ifOy?usp=sharing","2008,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1_unWeEVzYDMMCJC8_7M1co7Oihi2Dx0E?usp=sharing","2009,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1H-ZKajKhsbdm0kz9sa4P8ufNj9iEkvBM?usp=sharing","2010,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1YIPr_3d7kG6q8hvZy3XY67ru6d-PCDpL?usp=sharing","2011,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1ijMPHV2P5SrWmWDjjVWsPbUlTfyF6R8n?usp=sharing","2012,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1zRQ4NRFxwTJ5x-awhaZLPs8U9jsLI3gr?usp=sharing","2013,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1e995ePJW5SjAnzpI7tOwkn-n54S5tM29?usp=sharing","2014,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Mon0KEVqqUARTCn4qjPz1_L3-uab3zmS?usp=sharing","2015,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1wj0WzZ7qsaSZqJxgxtWxGEVJk_izkfxd?usp=sharing","2016,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1kVEGEnauc5d_SlHlEFsLgmk2FQkI590e?usp=sharing","2017,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1XL8vgNc4sW-AqCY-p9GjxnW6brT_92eF?usp=sharing","2018,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1kryc577YOaftLLxm_zo25iMJp66w2Ehs?usp=sharing","2019", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    #Oro
                                                    p(br(),strong(em("Oro - Valor aproximado producido (US$ por onzas troy)")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases panel en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1uvgpcqMN_CjB9iSLwcsj-iUEPHEQ-sKd?usp=sharing","2005,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Hdt3av87nPusTJqlPeOqinD75MrimTYO?usp=sharing","2006,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1QriVJAPw2AaI8RNtmy5Webvbss7mzHkw?usp=sharing","2007,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1prf588TkWvWai0_Xdb-7PEcMMtM9_3mH?usp=sharing","2008,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1IliVjQnQfyDz7wpduwObM8CQjCAqHOCF?usp=sharing","2009,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1kBMuI_-yxQ8XU2j_82skTYuqs6_V7UpY?usp=sharing","2010,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1h8Kl0sRt5gaWxkk0KOSedQBrP52gmA6u?usp=sharing","2011,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1MjpY3PdOFUTrdoBwVrbIdjtnzNioiwIy?usp=sharing","2012,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1F7vVBQK6cM19GpUsO-A2XdJezZdmjMTb?usp=sharing","2013,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1b11pC39RJK9ssigRcE1Zy1Cdw5yYd19c?usp=sharing","2014,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1DQuh0owiGS64z1fnrGBq8eyfxaJDiweG?usp=sharing","2015,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1kMSZOn1bS-Y7hwNPofyIyvlyefciK64V?usp=sharing","2016,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/13eOT3Y11Ocpyi1k8TjMKCgE6B16F_7jf?usp=sharing","2017,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Nd5dW6qNNIhpeVELQbUp-qliIz1hN2Vq?usp=sharing","2018,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Q5v1sETr5kAX9sk2OKt3AehLsl3gCl5c?usp=sharing","2019", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    #Plata
                                                    p(br(),strong(em("Plata - Valor aproximado producido (US$ por onzas troy)")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases panel en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/11lA1ptTRuszjlS-gQCUwixILHU30z2Go?usp=sharing","2006,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1RmgvWu1KCghBMkwCdmas9rG2AV3ZZiaw?usp=sharing","2007,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1PkyHB0T9KIoJOx6uIwwE7A-aIz3EhEIE?usp=sharing","2008,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1qMDmefqamuSysPWNYJutpFzDTt91CMJO?usp=sharing","2009,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1OqgRzO3wfsCDk1H_Pdjn9NTdpBK-Qp2B?usp=sharing","2010,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1GOG2tAmBh6PJckAETCpj91Zv5oy03LMR?usp=sharing","2011,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1N6IXqfVTLzBGCY5UFqx6vw2RkSempgH0?usp=sharing","2012,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/136ijJE6VKTlQl2rwHzGS5yG8mAsPtab4?usp=sharing","2013,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1MvYeJa5a2HYw4xJfGhcUM4Gbp9Rcd6BI?usp=sharing","2014,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1rdTEjge7Z4Avo2PAXMtoOAfrlSFVzYF8?usp=sharing","2015,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1PhFowJKVye31xDqYe_x9UN-2KJFlBqtS?usp=sharing","2016,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1y_8CfRE3vP-YD01_6cNQedARWz8Uw8ic?usp=sharing","2017,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1hY4Pd0kQgv1q8CU3cZaV5yjaHi1K6SY3?usp=sharing","2018,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1APPnP9Gg3qRbTHUj1Bk7aVfoKU163Bzd?usp=sharing","2019", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA",br(),br(),
                                                      "Nota: Se utilizaron las series mensuales del precio de la plata refinada para hallar el valor de producción aproximado"
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    #Zinc
                                                    p(br(),strong(em("Zinc - Valor aproximado producido (¢US$ por libras)")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases panel en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1ZE-IBjNgrEgOySip-2ajjPrFnc_kMjll?usp=sharing","2006,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1ci0tnaV8xTz463W-2pJZE5gz-aOvKeBW?usp=sharing","2007,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1RDps42WRjc-2omTnLwCEwOnEJWwpBrP_?usp=sharing","2008,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1zFNZCPq3YzCJTsNoWLT66Bz-cABhGA6b?usp=sharing","2009,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1aZYxlmYknzD2iEKzdWSxRWqc9vA3dOal?usp=sharing","2010,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1MDe-FCGaRoHY3XId4arw7CVyNRY7MOCw?usp=sharing","2011,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/14U14YHmZ8uw281Lrkda5kOX2qFVM7mln?usp=sharing","2012,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1ngDu76xP1v0cIdjJx7IJrag2rx8ADNfE?usp=sharing","2013,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1J1AX1X1O5ZcPuVyIYsqlXpYoL6yehdL2?usp=sharing","2014,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/17DaYV-k6w_YwwKyjp3X-vyj9tN_yUgfZ?usp=sharing","2015,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1Crasm_pCR9tvj1M8vbJ0CEm9J1fEUoJ6?usp=sharing","2016,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1_XfiZ4sEJbFh0-h1K3rV1C4mA35uZ6hL?usp=sharing","2017,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1VyU5br7s3Ms-nEhiZotWd8d_gNizUMLJ?usp=sharing","2018,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1hEKPhGF-yI4yjrUx-jKmY87p6emo1XnN?usp=sharing","2019", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    #Plomo
                                                    p(br(),strong(em("Plomo - Valor aproximado producido (¢US$ por libras)")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases panel en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1mYYpRC8NIYnA3DG730G1xWDDGf3XylAF?usp=sharing","2006,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1pCQDQfkqeelHwk6GFYvqGli2DYHenrlB?usp=sharing","2007,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1-GmRME3QUAGITqXOUlC13N5qdDfKDrnK?usp=sharing","2008,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1lcZaz2w5rUItPwZHwLiPVAv0cBJbKC6j?usp=sharing","2009,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1AvivpPsmSeqOoJ61E1GQcqxWxe1pz6rq?usp=sharing","2010,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1DUPyoxWytnLeuLPQ4XGM4dlCAoDSfUZg?usp=sharing","2011,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1oNF7fnz4CydYlNNFvEwPSYydDyhlxj3V?usp=sharing","2012,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1F5RAV7BuwIWjvwpQupAarZGVUuu2Y68w?usp=sharing","2013,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1FCaeUoabG6bxRjmHP9jK96otIpUJi5yb?usp=sharing","2014,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/10UtK481g-BBXOf42-oxGOITxwYFWzc0x?usp=sharing","2015,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1HNq0lJCleN5RjdcdKiDRJHNm2DMqO7YC?usp=sharing","2016,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/10NAwyFLYOjZikhGmN22MtzfkvxsVqAxC?usp=sharing","2017,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1mY9g4CBgv3X5-t6lWowd_zVa2qvq5CvG?usp=sharing","2018,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1vn5h1FikNzQwueP2WS9i4hk-MUoPk0vW?usp=sharing","2019", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),
                                                    
                                                    #Hierro
                                                    p(br(),strong(em("Hierro - Valor aproximado producido (US$ por toneladas)")),
                                                      style = "text-align:left;color:#14505B ;font-size: 14px"),
                                                    
                                                    p("Puede descargar las bases panel en los siguientes enlaces:", br(),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1EeEJ-yiijii1_nT5ofKICOOfdT7TuuXl?usp=sharing","2006,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1nmgqesWJ1Avtfkm0ZIB4_hirI-KJiI6c?usp=sharing","2007,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1t9lkecNt0ysUp7StXNcQR6jyPtqER8wE?usp=sharing","2008,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1hJKfcIFMWP79W-050_-AhshEgGUd73wl?usp=sharing","2009,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/12QRaLs9_6NmrM4WWWWlgT_CV5bsp2k-j?usp=sharing","2010,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1hqiMFE3UNKb6oGFzmTLdvSbjYBWvu8b3?usp=sharing","2011,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1zzOiF4jSSc6uvzJCW47zdlnXU3u1EQlt?usp=sharing","2012,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1F_VBo4ZJAngH9m80NUzd8Y8dW7uuB8K9?usp=sharing","2013,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1nsugCPcoTQIJSubtyGnelsOvXAeU2X-f?usp=sharing","2014,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1LQGPjv5oMcpv83TmPo9AI8L9MW9qJWMv?usp=sharing","2015,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1f69ZALfl5r545xJbMS71JG038UwQz9mI?usp=sharing","2016,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1bdVtuKsojdxWmAqVDxQIhjzCyfM8b6j8?usp=sharing","2017,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1ZjRm0b5XkQIecihvQc9R57YYq6uBdxd8?usp=sharing","2018,", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      strong(tags$a(href="https://drive.google.com/drive/folders/1BxyktK1wTtrvqKJrMkwTdWZDqnMlGGJV?usp=sharing","2019", target="_blank", style="color:#262626; text-decoration: underline")),
                                                      
                                                      br(),br(),"Formato: DTA"
                                                      , style = "text-align:justify; color: #4C4C4C; font-size: 14px"),

                                                    
                                             )
                                           )
                                       ) #,
                                       
                                     ),
                                     
                                     fluidRow(
                                       
                                       #CORREO
                                       box( width = 6, height = "40px", status = "primary", solidHeader = TRUE, 
                                            p("Consultas a", strong("qlab_csociales@pucp.edu.pe"),
                                              style = "font-family: Georgia;text-align:left;color:black ;font-size: 13px"),
                                       )
                                     )
                            ) #,
 
                          )
                        )
                ),
                #####################
                # Datos en línea
                ####################
                tabItem(tabName = "online_data",
                        
                        fluidRow(

                        tabBox(
                                #title = "Datos Web",
                                # The id lets us use input$tabset1 on the server to find the current tab
                                id = "online_tabset1", width = 12, height = "650px",
                                
                                #SALUD        
                                tabPanel("Salud", icon = icon("briefcase-medical"),
                                                 
                                        fluidRow(
                                                br(),
                                                #COVID 19
                                                box(em(strong("Covid-19: casos")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                                    style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                                         
                                                         fluidRow(
                                                                 column(12,
                                                                        br(),
                                                                        p(strong("Ministerio de Salud del Perú (MINSA)"),
                                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                                        
                                                                        p("Casos Positivos y Fallecidos por Covid-19 detallados según lugar, sexo, fecha y resultado"
                                                                          ,style = "text-align:justify; color: #4C4C4C ; font-size: 14px"),

                                                                        p(br(),strong(tags$a(href="https://www.datosabiertos.gob.pe/dataset/casos-positivos-por-covid-19-ministerio-de-salud-minsa/resource/690e57a6-a465-47d8-86fd", "Datos positivos por COVID-19", target="_blank", style="color:#262626; text-decoration: underline")),
                                                                          style = "text-align:left; font-size: 14px"),
                                                                        
                                                                        p("Base que cuenta con el total de casos reportados que dieron positivo a la Covid-19 por departamento, provincia y distrito, y
                                                                        según el tipo de prueba: rápida (PR) o molecular (PCR). Los datos están disponibles desde marzo del 2020 y se actualizan diariamente.",
                                                                          br(),br(), "Formato: CSV",
                                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                                        
                                                                        p(br(),strong(tags$a(href="https://www.datosabiertos.gob.pe/dataset/fallecidos-por-covid-19-ministerio-de-salud-minsa/resource/4b7636f3-5f0c-4404-8526", "Datos fallecidos por COVID-19", target="_blank", style="color:#262626; text-decoration: underline")),
                                                                          style = "text-align:left; font-size: 14px"),
                                                                        
                                                                        p("Base que cuenta con el total de fallecidos por la Covid-19 por departamento, provincia y distrito. Los datos están disponibles desde marzo del 2020 y se actualizan diariamente.",
                                                                          br(),br(), "Formato: CSV",
                                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px")
                                                                 )
                                                         )
                                                  
                                                 ),
     
                                                #VACUNACION
                                                box(em(strong("Covid-19: vacunación")),width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                                    style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                                    
                                                    fluidRow(
                                                      column(12,
                                                             br(),
                                                             p(strong("Ministerio de Salud del Perú (MINSA)"),
                                                               style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                             
                                                             p(br(),strong(tags$a(href="https://www.datosabiertos.gob.pe/dataset/vacunaci%C3%B3n-contra-covid-19-ministerio-de-salud-minsa/resource/db673c08-4812-4844-ae7f", "Datos vacunación para la COVID-19", target="_blank", style="color:#262626; text-decoration: underline")),
                                                               style = "text-align:left; font-size: 14px"),
                                                             
                                                             p("Base de datos que cuenta con el registro de los vacunados para la Covid-19 por departamento, provincia y distrito. Entre la información disponible en la base, se encuentra
                                                               la edad, sexo, grupo de riesgo, fecha de vacunación, el fabricante de la vacuna, entre otros. Los datos se actualizan diariamente",
                                                               br(),br(), "Formato: CSV",
                                                               style = "text-align:justify; color:#4C4C4C; font-size: 14px")
                                                      )
                                                    )
                                                    ),
                                                
                                                #FALLECIDOS
                                                box(em(strong("Fallecidos")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                                    style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                                    
                                                    fluidRow(
                                                      column(12,
                                                             br(),
                                                             p(strong("Sistema Informático Nacional de Defunciones (SINADEF)"),
                                                               style = "text-align:left;color:#14505B ;font-size: 16px"),

                                                             p(br(),strong(tags$a(href="https://www.datosabiertos.gob.pe/dataset/informaci%C3%B3n-de-fallecidos-del-sistema-inform%C3%A1tico-nacional-de-defunciones-sinadef-ministerio", "Datos fallecidos", target="_blank", style="color:#262626; text-decoration: underline")),
                                                               style = "text-align:left; font-size: 14px"),
                                                             
                                                             p("Base que se actualiza diariamente y cuenta con el registro de los fallecidos desde el 2017. Entre las variables que se incluyen, están las características individuales del fallecido 
                                                             como el tipo de seguro, sexo, edad, estado civil y nivel de instrucción. También se encuentra su país, departamento, provincia y distrito de residencia. Además, 
                                                             se incluye la causa de la muerte.",
                                                               br(),br(), "Formato: CSV",
                                                               style = "text-align:justify; color:#4C4C4C; font-size: 14px")
     
                                                      )
                                                    )
                                                 )

                                                 )     
                                                         
                                        ),
                                
                                #EDUCACIÓN 
                                tabPanel("Educación", icon = icon("school"),
                                         
                                         fluidRow(
                                           br(),
                                           #CENSO ESCOLAR
                                           box(em(strong("Censo escolar anual")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Estadística de la Calidad Educativa (ESCALE)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),strong(tags$a(href="http://escale.minedu.gob.pe/censo-escolar", "Registro de los censos escolares", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:left; font-size: 14px"),
                                                        
                                                        p("El censo escolar se realiza anualmente desde el año 2004. Desde entonces, se cuenta con información anual sobre  
                                                        las instituciones educativas públicas y privadas, y Programas No Escolarizados de todo el Perú. En específico, el censo cuenta con datos sobre los estudiantes matriculados,
                                                        niveles de atraso escolar, repetición, deserción, número de personal docente, infraestructura educativa, entre otros.",
                                                          
                                                        br(),br(),"Los datos disponibles del censo del 2020 se encuentran",strong(tags$a(href="http://escale.minedu.gob.pe/uee/-/document_library_display/GMv7/view/6226837","aquí", target="_blank", style="color:#262626; text-decoration: underline")),
                                                        br(),br(), "Formato: DBF",
                                                        style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                        
                                                 )
                                               )
                                               
                                           ),
                                           
                                           box(em(strong("Censo nacional universitario")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Instituto Nacional de Estadística e Informática (INEI)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),strong(tags$a(href="http://censos.inei.gob.pe/cenaun/redatam_inei/#", "Censo universitario-Consulta Resultados", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:left; font-size: 14px"),
                                                        
                                                        p("Censo realizado el 2010 que proporciona información sobre la situación demográfica, social, económica y académica de los estudiantes universitarios, docentes y
                                                          trabajadores no docentes en las universidades públicas y privadas del Perú. Además, se encuentra información sobre los aspectos organizacionales, las características de la infraestructura y de los recursos
                                                          físicos en equipamiento, entre otros.
                                                          ",
                                                          br(),br(), "Formato: XLS, JPG",
                                                          br(),br(),"Los bases de datos sin procesar se encuentran en la consulta por encuesta de los ",strong(tags$a(href="http://iinei.inei.gob.pe/microdatos/","Microdatos-INEI", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                        
                                                 )
                                               )
                                               
                                           )
                                           
                                         )
                                         ),
                                
                                #EMPLEO
                                tabPanel("Empleo", icon = icon("briefcase"),
                                         
                                         fluidRow(
                                           br(),
                                           #MICRODATOS
                                           box(em(strong("Microdatos")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                                
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Ministerio de Trabajo y Promoción del Empleo (MTPE)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),

                                                        p(br(),strong(tags$a(href="https://www2.trabajo.gob.pe/promocion-del-empleo-y-autoempleo/informacion-del-mercado-de-trabajo/microdatos/", "Microdatos: empleo e ingresos", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:left; font-size: 14px"),
                                                        
                                                        p("Bases de datos que contienen información del módulo de Empleo e Ingresos de la Encuesta Nacional de Hogares sobre Condiciones de Vida 
                                                        y Pobreza (ENAHO) para los años 2004-2018 y 2001-2017.
                                                        ",
                                                        br(), br(), "Formato: DTA",
                                                        style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                        
                                                 )
                                               )
                                               
                                           ),
                                           
                                           
                                         )
                                         ),
                                
                                #INDUSTRIA
                                tabPanel("Industria", icon = icon("trailer"),
                                         
                                         fluidRow(
                                           br(),
                                           #CENSO NACIONAL ECONÓMICO
                                           box(em(strong("Censo Nacional Económico")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Instituto Nacional de Estadística e Informática (INEI)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),"Existen dos censos económicos: el del 1993-1994 y el del 2008. En estos, se censaron a empresas y establecimientos por actividad económica.
                                                        Se proporciona información sobre el número de establecimientos y empresas, su ubicación y actividad económica, sus remuneraciones, su cantidad de personal ocupado, sus ingresos y egresos, sus activos fijos 
                                                        , y su valor agregado.
                                                        ",
                                                          br(),br(),"El sistema de consulta de los resultados de los dos censos se pueden encontrar en los siguientes enlaces:",
                                                          br(),br(),strong(tags$a(href="http://censos.inei.gob.pe/bcoCuadros/IIICenec.htm","Censo Nacional Económico 1993-94", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          br(),br(),strong(tags$a(href="http://censos.inei.gob.pe/cenec2008/redatam_inei/","Censo Nacional Económico 2008", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                        
                                                 )
                                               )
                                               
                                           ),
                                           
                                           #ENCUESTA ECONÓMICA ANUAL
                                           box(em(strong("Encuesta Económica Anual (EEA)")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Instituto Nacional de Estadística e Informática (INEI)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),"Esta encuesta se realiza anualmente y cuenta con información disponible desde el año 2001. La encuesta
                                                        está dirigida a empresas y establecimientos por actividad económica en los 24 departamentos del país y
                                                        la Provincia Constitucional del Callao. Se recopila información de los siguientes sectores: agencia de viajes, agroindustria,
                                                        centros educativos no estatales, comercio, construcción, hospedaje, hidrocarburos, pesca, manufactura, electricidad, entre otros.
                                                        La información está referida a nivel de empresa y nivel de establecemiento (sectores productivos).
                                                        ",
                                                          br(),br(), "La última encuesta se realizó el 2018. La base de datos se encuentra disponible",strong(tags$a(href="https://www.datosabiertos.gob.pe/dataset/encuesta-econ%C3%B3mica-anual-eea-2018-instituto-nacional-de-estad%C3%ADstica-e-inform%C3%A1tica-inei","aquí", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          br(),br(),"Para información de años anteriores, revisar en la consulta por encuestas de los",strong(tags$a(href="http://iinei.inei.gob.pe/microdatos/","Microdatos-INEI", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                        
                                                 )
                                               )
                                               
                                           )
                                           
                                         )
                                         
                                         ),
                                
                                #AGROPECUARIO
                                tabPanel("Agropecuario", icon = icon("leaf"),
                                         
                                         fluidRow(
                                           br(),
                                           
                                           #CENSO NACIONAL AGROPECUARIO
                                           box(em(strong("Censo Nacional Agropecuario")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Instituto Nacional de Estadística e Informática (INEI)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),"Existen dos censos agropecuarios: el del 1994 y el del 2012. Estos proporcionan información de las unidades agropecuarias del país que puede ser desagregada a nivel distrital.
                                                          Entre las variables que podemos encontrar, están
                                                          las características del productor agropecuario y de la unidad agropecuaria, el uso de la tierra, las principales practicas agropecuarias, entre otras.",
                                                          br(),br(),"El sistema de consulta de los resultados de los dos censos se pueden encontrar en los siguientes enlaces:",
                                                          br(),br(),strong(tags$a(href="http://censos.inei.gob.pe/bcoCuadros/IIIcenagro.htm","Censo Nacional Agropecuario 1994", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          br(),br(),strong(tags$a(href="http://censos.inei.gob.pe/Cenagro/redatam/","Censo Nacional Agropecuario 2012 ", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          br(),br(),"Los bases de datos sin procesar del censo del 2012 se encuentran en la consulta por encuesta de los ",strong(tags$a(href="http://iinei.inei.gob.pe/microdatos/","Microdatos-INEI", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                        
                                                 )
                                               )
                                           ),
                                           
                                         )
                                         
                                         ),
                                
                                #CUENTAS FISCALES       
                                tabPanel("Cuentas fiscales", icon = icon("hand-holding-usd"),
                                         
                                         fluidRow(
                                           br(),
                                           
                                           #Ejecución presupuestal
                                           box(em(strong("Seguimiento de la Ejecución Presupuestal")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Ministerio de Economía y Finanzas (MEF)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),strong(tags$a(href="https://www.mef.gob.pe/es/?option=com_content&language=es-ES&Itemid=100944&lang=es-ES&view=article&id=504", "Ejecución presupuestal-Consulta Amigable", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:left; font-size: 14px"),
                                                        
                                                        p("Bases de datos que contienen información para los tres niveles de gobierno (nacional, local y regional) sobre el Módulo del Presupuesto Institucional de Apertura (PIA), el Presupuesto Institucional Modificado (PIM), 
                                                          la ejecución de ingreso en la fase de Recaudado, y la ejecución de gasto en las fases de Compromiso, Devengado y Girado. En su mayoría, estas bases se encuentran disponibles desde alrededor del 2000.
                                                          ",
                                                          br(), br(), "Formato: XLSX",
                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                        
                                                 )
                                               )
                                           ),

                                         )                 
                                         
                                         ),

                                #GOBERNABILIDAD            
                                tabPanel("Gobernabilidad", icon = icon("vote-yea"),
                                         
                                         fluidRow(
                                           br(),
                                           #Elecciones
                                           box(em(strong("Elecciones")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Infogob"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),strong(tags$a(href="https://infogob.jne.gob.pe/BaseDatos", "Datos infogob", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:left; font-size: 14px"),
                                                        
                                                        p("Base que contiene datos sobre los distintos tipos de elecciones (presidenciales, congresales, parlamento andino, regionales, entre otros).
                                                          En específico, se dispone de información sobre los candidatos, los resultados, el padrón electoral y las autoridades electas. ",
                                                    
                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px"),
                                                        
                                                        br(),
                                                        p(strong("Oficina Nacional de Procesos Electorales (ONPE)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),strong(tags$a(href="https://www.onpe.gob.pe/elecciones/historico-elecciones/", "Histórico de elecciones", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:left; font-size: 14px"),
                                                        
                                                        p("Bases que cuentan con información sobre el histórico de elecciones desde el 2000 hasta el 2021 para los distintos procesos electorales (elecciones generales,
                                                          internas, congresales,  municipalidades, entre otros). La información se pude desagregar hasta nivel distrital.",
                                                          br(),br(), "Formato: PDF, CSV",
                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px")
                                                 )
                                               )
                                               
                                           ),
                                           
                                           #Municipalidades
                                           box(em(strong("Registro Nacional de Municipalidades (RENAMU)")),width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Instituto Nacional de Estadística e Informática (INEI)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),"Base de datos que se actualiza anualmente, y que contiene información estadística desde el 2004 hasta la actualidad de las municipalidades provinciales, distritales y de centros poblados del Perú.
                                                          En específico, esta dispone de información sobre los datos generales de las municipalidades, su equipamiento y tecnologías, sus recursos humanos, sus servicios públicos locales, entre otros.",
                                                          br(),br(), "El último registro se realizó el 2020. La base de datos se encuentra disponible",strong(tags$a(href="https://www.datosabiertos.gob.pe/dataset/registro-nacional-de-municipalidades-renamu-2020-instituto-nacional-de-estad%C3%ADstica-e","aquí", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          br(),br(), "Formato: CSV",
                                                          br(),br(),"Para información de años anteriores, revisar en la consulta por encuestas de los",strong(tags$a(href="http://iinei.inei.gob.pe/microdatos/","Microdatos-INEI", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px")
                                                 )
                                               )
                                           )

                                         )  
                     
                                         ),
                                
                                #HOGARES
                                tabPanel("Población y Hogares", icon = icon("user-friends"),
                                         
                                         fluidRow(
                                           br(),
                                           #Censo Nacional
                                           box(em(strong("Censos Nacionales de Población y Vivienda")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               fluidRow(
                                                 column(12,
                                                        br(),
                                                        p(strong("Instituto Nacional de Estadística e Informática (INEI)"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),

                                                        p(br(),"Existen cincos censos realizados en los siguientes años: 1981, 1993, 2005, 2007 y 2017. Estos cuentan con información sobre preguntas de vivienda, hogar y población. En específico,
                                                          dentro de las principables características de la bases, se encuentran datos sobre la estructura y composición de la población, y sobre las viviendas 
                                                          particulares y hogares. Claramente, estos censos permiten la inferencia nacional. Además, se pueden desagregar los datos por departamentos, provincias o distritos.",
                                                          br(),br(),"El sistema de consulta de los resultados de los censos se pueden encontrar en los siguientes enlaces:",
                                                          br(),br(),strong(tags$a(href="https://censos2017.inei.gob.pe/redatam/","Censo Nacional 2017", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          br(),br(),strong(tags$a(href="http://censos.inei.gob.pe/Censos2007/redatam/","Censo Nacional 2007", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          br(),br(),strong(tags$a(href="http://censos.inei.gob.pe/Censos2005/redatam/","Censo Nacional 2005", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          br(),br(),strong(tags$a(href="http://censos.inei.gob.pe/censos1993/redatam/","Censo Nacional 1993", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          br(),br(),strong(tags$a(href="http://censos.inei.gob.pe/censos1981/redatam/","Censo Nacional 1981", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:justify; color:#4C4C4C; font-size: 14px")
                                                        
                                                 )
                                               )
                                           ),
                                           
                                         #ENAHO
                                         box(em(strong("Encuesta Nacional de Hogares (ENAHO)")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                             style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                             
                                             fluidRow(
                                               column(12,
                                                      br(),
                                                      p(strong("Instituto Nacional de Estadística e Informática (INEI)"),
                                                        style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                      
                                                      p(br(),"Es una encuesta permanente que se desarrolla de manera anual y continua desde mayo del 2003, en rondas trimestrales. Esta permite la inferencia a nivel nacional y área de residencia.
                                                        Cuenta con información sobre variables como las características de la vivienda y del hogar,
                                                        las características de los miembros del hogar, educación, salud, empleo, sistema de pensiones, inclusión financiera, ingresos, gastos, programas sociales, participación ciudadana,
                                                        entre otros.",
                                                        br(),br(),"Los datos disponibles de la ENAHO del 2019 se encuentran",strong(tags$a(href="https://www.datosabiertos.gob.pe/dataset/encuesta-nacional-de-hogares-enaho-2019-instituto-nacional-de-estad%C3%ADstica-e-inform%C3%A1tica-inei","aquí", target="_blank", style="color:#262626; text-decoration: underline")),
                                                        br(),br(), "Formato: CSV",
                                                        br(),br(),"Para información más actualizada o de años anteriores revisar en la consulta por encuesta de los",strong(tags$a(href="http://iinei.inei.gob.pe/microdatos/","Microdatos-INEI", target="_blank", style="color:#262626; text-decoration: underline")),
                                                        style = "text-align:justify; color:#4C4C4C; font-size: 14px")
                                                      
                                               )
                                             )
                                         ),
                                         
                                         #ENDES
                                         box(em(strong("Encuesta Demográfica y de Salud Familiar (ENDES)")), width = 4, height = "600px", status = "primary", solidHeader = TRUE, 
                                             style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                             
                                             fluidRow(
                                               column(12,
                                                      br(),
                                                      p(strong("Instituto Nacional de Estadística e Informática (INEI)"),
                                                        style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                      
                                                      p(br(),strong(tags$a(href="https://proyectos.inei.gob.pe/endes/documentos.asp", "Datos ENDES", target="_blank", style="color:#262626; text-decoration: underline")),
                                                        style = "text-align:left; font-size: 14px"),
                                                      
                                                      p("Encuesta anual que se realiza desde 1996 hasta la actualidad, y que dispone de datos a nivel de hogares sobre la salud reproductiva, salud materna y salud infantil, 
                                                          uso de métodos anticonceptivos, atención del embarazo y parto, enfermedades en infantes, inmunizaciones, talla y peso de niños menores de 5 años y de sus madres, violencia intrafamiliar, entre otros.",
                                                        br(),br(), "Formato: SPSS, DBF",
                                                        style = "text-align:justify; color:#4C4C4C; font-size: 14px")
                                                      
                                               )
                                             )
                                         )
                                         
                                         )
                                         ),
                                
                                #OTROS REPOSITORIOS
                                tabPanel("Otros", icon = icon("th"),
                                         fluidRow(
                                           br(),
                                           #MICRODATOS
                                           box( width = 12, height = "600px", status = "primary", solidHeader = TRUE, 
                                               style = "font-family: Georgia;text-align:left;color:#14505B ;font-size: 28px; padding-top: 20px",
                                               
                                               
                                               fluidRow(
                                                 column(12,
                                                        p(strong("Catálogo de Bases-INEI"),
                                                          style = "text-align:left;color:#14505B ;font-size: 16px"),
                                                        
                                                        p(br(),strong(tags$a(href="https://www.inei.gob.pe/media/difusion/apps/", "Bases de Datos 2021-INEI", target="_blank", style="color:#262626; text-decoration: underline")),
                                                          style = "text-align:left; font-size: 14px")
                                                        
                                                 )
                                               )
                                               
                                           ),
                                           
                                           
                                         )
                                      )
                                
                                #PROGRAMAS SOCIALES
                                #tabPanel("Programas sociales", icon = icon("hands-helping"),
                                         
                                 #        "Tab content 2")
                                        
                                        )

                        )
                        )
      )
)



shinyApp(
        ui = dashboardPage(skin = "red",
                           header, sidebar, body),
        
        server = function(input, output) {
                #DATOS PROCESADOS Y GENERADOS
                
                #COVID
                output$db_qlab_covid <- downloadHandler(
                        filename = function() {
                                
                                if(input$qlab_covid == "Panel mensual a nivel nacional"){
                                        "Covid_nac_panel.csv"
                                }
                                else if(input$qlab_covid == "Panel mensual a nivel departamental"){
                                        "Covid_dep_panel.csv"
                                }
                                else if(input$qlab_covid == "Panel mensual a nivel provincial"){
                                        "Covid_prov_panel.csv"
                                        
                                }else{
                                        "Covid_dist_panel.csv" 
                                }
                                
                        },
                        content = function(file) {
                                
                                if(input$qlab_covid == "Panel mensual a nivel nacional"){
                                        write.csv(covid_nac, file, row.names = FALSE)
                                        
                                }
                                else if(input$qlab_covid == "Panel mensual a nivel departamental"){
                                        write.csv(covid_dep, file, row.names = FALSE)
                                        
                                }
                                else if(input$qlab_covid == "Panel mensual a nivel provincial"){
                                        write.csv(covid_prov, file, row.names = FALSE)   
                                        
                                }else{
                                        write.csv(covid_dist, file, row.names = FALSE)
                                } 
                        }
                )
        }
)


