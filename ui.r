library(shiny)   
library(shinythemes) 
library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(shinyalert)
library(odbc)
library(RMySQL)
library(shinyjs)

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
        tabPanel("Daily PICK_UP"),
    tabPanel("CUSTOMER REGISTRATION",
             absolutePanel(id="controls",
                           style="position: fixed;left: 371px;top: 194px; background-color:#F9F9F0;width:757px;padding-bottom:521px;",
                           class = "panel panel-default",
                           draggable = FALSE,
                           h4(textOutput("first_name"), style = "position:fixed;top:210px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                           h4(textOutput("second_name"), style = "position:fixed;top:254px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                           h4(textOutput("store_name"), style = "position:fixed;top:298px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                           h4(textOutput("phone_number"), style = "position:fixed;top:342px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                           h4(textOutput("item_desc"), style = "position:fixed;top:386px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                           h4(textOutput("item_quantity"), style = "position:fixed;top:430px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                           h4(textOutput("mpesa_code"), style = "position:fixed;top:474px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                           conditionalPanel(
                             condition = "input.first !='' && input.last != '' && input.stores1 != ''&& input.description != '' && input.numbers != '' && input.dob != '' && input.quantity != '' && input.mpesa != '' ",
                             h4(textOutput("confirmation_text"), style = "font-style:italic;position:fixed;top:518px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                             
                             
                           ),
                           ),
             h3 ("Customer Registration(To Be Registered During Drop Off)"),
             textInput("first","First Name"),
             textInput("last","Second Name"),
             selectInput("stores1","Select A Store", choices= c("","Malazi Store", "Majengo Store","Online Dress","Online Furniture"),  multiple = FALSE),
             
             textInput("numbers","Cell Phone Numers (10 digits):" ),
             textAreaInput("description", "Item Description", placeholder = "Please Describe the Item"),
             
             numericInput("quantity", "Number Of Items",value = 1, min = 1, max = 100000,step = 1),
             textInput("mpesa", "Enter MPESA Payment Code"),
             verbatimTextOutput("value"),
             conditionalPanel(
               condition = "input.first !='' && input.last != '' && input.stores1 != ''&& input.description != '' && input.numbers != '' && input.dob != '' && input.quantity != '' && input.mpesa != '' ",
               
               span(actionButton("subit","Register Details"), 
                    style = "position:fixed;left:679px;top:590px;width:184px;height:47px;color:red;")
               # position: absolute;
               # right: 80em;
               # top: -176px;
               # background-color: green;


             ),

             ),
    tabPanel("PICK_UP",
             selectInput("stores","Select A Store", choices= c("","Malazi Store", "Majengo Store","Online Dress","Online Furniture"),  multiple = FALSE),
             verbatimTextOutput('x4'),
             verbatimTextOutput('mpesaconfirmation'),
             
             conditionalPanel(
               condition = "input.table_rows_selected != ''",
               
               span(textInput("mpesacon",""),
                    #style = "position:fixed;left:679px;top:590px;width:184px;height:47px;color:red;"
                    ),
               actionButton("verify","Verify MPESA Code"),
               ),
             
             dataTableOutput("table")
             ))))
    
  
)