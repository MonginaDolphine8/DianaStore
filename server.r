library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(shinythemes)
library(shinyalert)
library(odbc)
library(RMySQL)

#data <- read.csv("Customer_Data.csv")

con <- DBI::dbConnect(odbc::odbc(),
                      driver = "MySQL ODBC 8.0 Unicode Driver",
                      database = "test_db",
                      UID    = "root",
                      PWD    = "Purity@8",
                      host = "localhost",
                      port = 3306)

rs = dbSendQuery(con, "SELECT * FROM customer_data")
data <- dbFetch(rs)

isValidEmail <- function(x) {
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x),
        ignore.case=TRUE)
}
server <- function(input, output, session) {
  output$tableforpatient <- renderText({
    validate(
      need(input$first !="", 
           paste("First Name: Please Input your firstname")),
      need(input$last !="", 
           paste("Second Name: Please Input your lastname")),
      need(input$numbers !="", 
           paste("Phone Number: Please Input your Phone Number")),
           need(isValidEmail(input$email),
                paste("Email Address: Please Input a valid E-mail address"))
      )
    # 
    # patient <- data.frame(firstname=input$first,
    #                       lastname=input$last,
    #                       dob=input$dob,
    #                       email=input$email)
    
    
    
  })
  # observeEvent(input$subit, {
  #   showModal(modalDialog(
  #     title = "Please Confirm Details",
  #     print(paste("Fisrt Name: ",input$first)),
  #     print(paste("Second Name: ",input$last))
  #   ))
  # })
  
  
  observeEvent(input$btn, {
    shinyalert(
      title = "Please Confirm Details",print(paste0("Fisrt Name: ",input$first,sep="\n")),
      # print(paste0("Second Name: ",input$last,sep="\n")),
      # print(paste0("Store Name:",input$stores1, sep="\n")),
      # callbackR = function() { shinyalert(paste("Registration Successful!")) }
      callbackR = function() { shinyalert(paste("Registration Successful!"), showConfirmButton = TRUE) }
    )
  })
  observeEvent(input$subit,{

#     query <-"INSERT INTO customer_data 
# VALUES(%s,input$first
# %s,input$stores1
# %d,input$numbers);"
    

    dbGetQuery(con
               ,paste0("Insert customer_data 
                        values ('",input$first,"','",input$stores1,"','",input$numbers,"')"))
    
    #dbSendQuery(con, query)
    #dbGetQuery(con, query)
    dbDisconnect(con)
    })
  # 
  # observeEvent(input$subit,{
  #   
  #   output$last <- renderText({
  #     print(paste0("Second Name: ",input$last)) 
  #   })})
  
  output$mycomment <- renderText(input$Comment)
  
  output$myInvestor <- renderText(input$Investor)
  
  output$myDistrictNames <- renderText(input$DistrictNames)
  
  output$datatable <- DT::renderDataTable({
    con <- DBI::dbConnect(odbc::odbc(),
                          driver = "MySQL ODBC 8.0 Unicode Driver",
                          database = "test_db",
                          UID    = "root",
                          PWD    = "Purity@8",
                          host = "localhost",
                          port = 3306)
    
    rs = dbSendQuery(con, "SELECT * FROM customer_data")
    data <- dbFetch(rs)

      data <- filter(data, data$Store == input$stores) 

  })
  
  
  
  
}