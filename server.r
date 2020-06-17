library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(shinythemes)

data <- read.csv("Customer_Data.csv")

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
  observeEvent(input$subit,{
  
output$first <- renderText({
    print(paste0("Fisrt Name: ",input$first)) 
  })})
  
  observeEvent(input$subit,{
    
    output$last <- renderText({
      print(paste0("Second Name: ",input$last)) 
    })})
  
  output$mycomment <- renderText(input$Comment)
  
  output$myInvestor <- renderText(input$Investor)
  
  output$myDistrictNames <- renderText(input$DistrictNames)
  
  output$datatable <- DT::renderDataTable({

      data <- filter(data, data$Store == input$stores) 

  })
  
  
  
  
}