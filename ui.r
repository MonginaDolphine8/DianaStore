library(shiny)   
library(shinythemes) 
library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(shinyalert)
library(odbc)
library(RMySQL)

con <- DBI::dbConnect(odbc::odbc(),
                      driver = "MySQL ODBC 8.0 Unicode Driver",
                      database = "test_db",
                      UID    = "root",
                      PWD    = "Purity@8",
                      host = "localhost",
                      port = 3306)

ui =  tagList(includeCSS('shop.css'),
              
  tags$head(tags$style(HTML("
                           .navbar-nav {
                           float: none !important;
                           }
                           .navbar-nav > li:nth-child(1) {
                           float: right;
                           right: 230px;
                           }
                           .navbar-nav > li:nth-child(2) {
                           float: right;
                           
                           }
                           "))),
  navbarPage(
    title = "DEE Drop Off, Pick Up",
    theme = shinytheme("cerulean"),

    tabPanel("HOME",htmlOutput("hyper")),
    tabPanel("CUSTOMER",
      tabsetPanel(
    tabPanel("CUSTOMER REGISTRATION",
             h3 ("Customer Registration(To Be Registered During Drop Off)"),
             textInput("first","First Name"),
             textInput("last","Second Name"),
             selectInput("stores1","Select A Store", choices= c("","Malazi Store", "Majengo Store","Online Dress","Online Furniture"),  multiple = FALSE),
             textInput("numbers","Cell Phone Numers (10 digits):", placeholder = "+254"),
             textInput("email","Enter Email Address"),
             dateInput("dob","Date of Drop_off:",format = "dd-mm-yyyy"),
             numericInput("quantity", "Number Of Items",value = 1, min = 1, max = 100000,step = 1),
             textInput("mpesa", "Enter MPESA Payment Code"),
             conditionalPanel(
               condition = "input.first !='' && input.last != '' && input.stores1 != '' && input.numbers != '' && input.email != '' && input.dob != '' && input.quantity != '' && input.mpesa != '' ",
               actionButton("subit","Register Details"),
               
               
             ),
             #actionButton("subit","Register Details"),
             useShinyalert(rmd = FALSE),  # Set up shinyalert
             actionButton("btn", "Greet"),
             textOutput("tableforpatient"),
             h6(textOutput("first") , style ="position: fixed;color:blue;left: 379px;top:156px;font-size:35px;font-weight:bold;"),
             h6(textOutput("last") , style ="position: fixed;color:blue;left: 379px;top:220px;font-size:35px;font-weight:bold;")
             ),
    tabPanel("PICK_UP",
             selectInput("stores","Select A Store", choices= c("","Malazi Store", "Majengo Store","Online Dress","Online Furniture"),  multiple = FALSE),
             dataTableOutput("datatable")
             ))))
    
  
)