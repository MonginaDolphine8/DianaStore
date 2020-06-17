library(shiny)   
library(shinythemes) 
library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)


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

    tabPanel("HOME"),
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
             actionButton("subit","Register Details"),
             textOutput("tableforpatient"),
             h6(textOutput("first") , style ="position: fixed;color:blue;left: 379px;top:156px;font-size:35px;font-weight:bold;"),
             h6(textOutput("last") , style ="position: fixed;color:blue;left: 379px;top:220px;font-size:35px;font-weight:bold;")
             ),
    tabPanel("PICK_UP",
             selectInput("stores","Select A Store", choices= c("","Malazi Store", "Majengo Store","Online Dress","Online Furniture"),  multiple = FALSE),
             dataTableOutput("datatable")
             ))))
    
  
)