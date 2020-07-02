library(shiny)   
library(shinythemes) 
library(shiny)
library(shinyWidgets)
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
    #setBackgroundImage(src = "Home.png"),
    setBackgroundColor(
      color = c("#fdeabf")
    ),
      tabsetPanel( 
#         tags$head(
#           tags$style(HTML("body{
#          
#           background-image: url( WhatsApp Image 2020-07-02 at 13.53.40.jpg );
# 
# }"))),
        #tags$h2("Add a shiny app background image"),

        tabPanel("Daily PICK_UP",


                               conditionalPanel(
                                 condition = "input.dfirst !='' && input.dlast != '' && input.dstore != ''&& input.ddescription != '' && input.dnumbers != '' && input.dquantity != '' ",
                                 absolutePanel(id="controls1",
                                               style="position: fixed;left: 371px;top: 194px; background-color:#F9F9F0;width:757px;padding-bottom:521px;",
                                               
                                               draggable = FALSE,
                                               h4(textOutput("d_first"), style = "position:fixed;top:210px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                                               h4(textOutput("d_last"), style = "position:fixed;top:254px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                                               h4(textOutput("d_store"), style = "position:fixed;top:298px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                                               h4(textOutput("d_number"), style = "position:fixed;top:342px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                                               h4(textOutput("d_description"), style = "position:fixed;top:386px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                                               h4(textOutput("d_quantity"), style = "position:fixed;top:430px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                                 h4(textOutput("d_confirmation_text"), style = "font-style:italic;position:fixed;top:474px;left:378px;font-size:16px;font-weight:bold;color:green;"),
                                 span(actionButton("submit","Register Details"), 
                                      style = "position:fixed;left:530px;top:590px;width:1921px;height:47px;color:red;"),
                                 
                               ),
                               ),

                 h3 ("Customer Registration - For Customers Seeking Daily Services"),
          textInput("dfirst", "First Name"),  
          textInput("dlast", "Second Name"),
          textInput("dstore", "Enter The Name of the Store"),
          textInput("dnumber", "Enter Phone Number(10 Digits)"),
          textAreaInput("ddescription", "Item Description", placeholder = "Please Describe the Item"),
          numericInput("dquantity", "Number Of Items",value = 1, min = 1, max = 100000,step = 1),
          span(dateInput("ddated", "Date Of Pick-UP:", value = Sys.Date(), min = (Sys.Date()), max = "2022-02-29"), 
               style = "position:fixed;left:189px;width:124px;color:black;top:650px;"),
          span(dateInput("ddatep", "Date Of Drop-Off:", value = Sys.Date(), min = (Sys.Date()), max = "2022-02-29"), 
               style = "position:fixed;left:12px;top:650px;width:122px;top:650px;color:black;"),
          span(verbatimTextOutput("damount"),
               style = "position:fixed;left:12px;top:700px;width:302px;top:728px;color:red;"),

                 
                 ),
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
                    style = "position:fixed;left:679px;top:590px;width:184px;height:47px;color:red;"),
               # position: absolute;
               # right: 80em;
               # top: -176px;
               # background-color: green;


             ),

             ),
    tabPanel("PICK_UP",
             selectInput("stores","Select A Store", choices= c("","Malazi Store", "Majengo Store","Online Dress","Online Furniture"),  multiple = FALSE),
             span(actionButton("refresh","Refresh Data"),
                  style = "position:fixed;top:126px;right:20px;"
             ),
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