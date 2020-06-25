library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(shinythemes)
library(shinyalert)
library(odbc)
library(RMySQL)
library(shinyjs)

#data <- read.csv("Customer_Data.csv")



isValidEmail <- function(x) {
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x),
        ignore.case=TRUE)
}
server <- function(input, output, session) {
  
  ######DAILY VALUS###########
  
  output$damount <- renderText({
    p <- (input$ddatep - input$ddated)*100
    paste0("Amount Owned:",p) })
  
  
  observeEvent(input$dfirst,{
    output$d_first <- renderText({
      print(paste0("First Name: ",  input$dfirst))
    })})
  
  observeEvent(input$dlast,{
    output$d_last <- renderText({
      print(paste0("Second Name: ",  input$dlast))
    })})
  
  observeEvent(input$dstore, {
    output$d_store <- renderText({
      print(paste0("Name of The Store: ",  input$dstore))
    })})
  
  observeEvent(input$dnumber,{
    output$d_number <- renderText({
      print(paste0("Phone Number:",  input$dnumber))
    })})
  
  observeEvent(input$ddescription,{
    output$d_description <- renderText({
      print(paste0("Item Description:",  input$ddescription))
    })})
  
  observeEvent(input$dquantity,{
    output$d_quantity <- renderText({
      print(paste0("Quantity:",  input$dquantity))
    })})
  
  
  output$d_confirmation_text<- renderText({
    print(paste0("Please Confirm That The Detail Provided Above Are Correct Before Pressing The Submit Button"))
  })
  
######################################################################################################################  
  
  output$hyper <- renderUI({
    tags$iframe(src= "index.html", style="width: 100vw;height: 100vh;position: relative;", frameborder="0")
  })
  output$tableforpatient <- renderText({
    validate(
      need(input$first !="", 
           paste("First Name: Please Input your firstname")),
      need(input$last !="", 
           paste("Second Name: Please Input your lastname")),
      need(input$numbers !="", 
           paste("Phone Number: Please Input your Phone Number")),
      need(input$stores1 !="", 
           paste("Store Name: Please Provide the Store Name")),
           # need(isValidEmail(input$email),
           #      paste("Email Address: Please Input a valid E-mail address"))
      need(input$description !="", 
           paste("Item Description: Please Describe the Item")),
      need(input$mpesa !="", 
           paste("MPESA Code: Please Provide the MPESA verification Code"))
      )})
  # observeEvent(input$subit, {
  #   showModal(modalDialog(
  #     title = "Please Confirm Details",
  #     print(paste("Fisrt Name: ",input$first)),
  #     print(paste("Second Name: ",input$last))
  #   ))
  # })
  
  
  output$value <- renderText({paste0("Date Of Drop Off:",Sys.Date()) })
  
  
  
  observeEvent(input$btn, {
    shinyalert(
      title = "Please Confirm Details",print(paste0("Fisrt Name: ",input$first,sep="\n")),
      # print(paste0("Second Name: ",input$last,sep="\n")),
      # print(paste0("Store Name:",input$stores1, sep="\n")),
      # callbackR = function() { shinyalert(paste("Registration Successful!")) }
      callbackR = function() { actionButton("data","Confirm") }
    )
  })
  observeEvent(input$subit,{

#     query <-"INSERT INTO customer_data 
# VALUES(%s,input$first
# %s,input$stores1
# %d,input$numbers);"
    con <- DBI::dbConnect(odbc::odbc(),
                          driver = "MySQL ODBC 8.0 Unicode Driver",
                          database = "test_db",
                          UID    = "root",
                          PWD    = "Purity@8",
                          host = "localhost",
                          port = 3306)
    


    dbGetQuery(con
               ,paste0("Insert customer_data 
                        values ('",input$first,"','",input$stores1,"','",input$numbers,"','","Pending","')"))
    
    #dbSendQuery(con, query)
    #dbGetQuery(con, query)
    dbDisconnect(con)
    updateTextInput(session, "first", value = "")
    updateTextInput(session, "last", value = "") 
    updateSelectInput(session,"stores1","Select A Store", choices= c("","Malazi Store", "Majengo Store","Online Dress","Online Furniture"))
    updateTextInput(session, "numbers",value = "") 
    updateTextInput(session, "email", value = "") 
    updateDateInput(session, "dob", value = Sys.Date()) 
    updateNumericInput(session, "quantity", value = 1) 
    updateTextInput(session, "mpesa", value = "")
    updateTextAreaInput(session, "description", "Item Description", value = "",placeholder = "Please Describe the Item")
    
    
    })
  

  
  
  
  output$table <- DT::renderDataTable({
    con <- DBI::dbConnect(odbc::odbc(),
                          driver = "MySQL ODBC 8.0 Unicode Driver",
                          database = "test_db",
                          UID    = "root",
                          PWD    = "Purity@8",
                          host = "localhost",
                          port = 3306)
    
    rs <- dbSendQuery(con, "SELECT * FROM customer_data")
    data <- dbFetch(rs)
    data <- filter(data, data$Store == input$stores) 

    datatable(data) %>% 

        
        formatStyle(
          'Status',
          backgroundColor = styleEqual(c("Pending", "Picked"), c('green', 'red'))) 
    
      #dbDisconnect(con)


  })
  
  output$x4 = renderPrint({
    con <- DBI::dbConnect(odbc::odbc(),
                          driver = "MySQL ODBC 8.0 Unicode Driver",
                          database = "test_db",
                          UID    = "root",
                          PWD    = "Purity@8",
                          host = "localhost",
                          port = 3306)
    
    rs <- dbSendQuery(con, "SELECT * FROM customer_data")
    data <- dbFetch(rs)
    data <- filter(data, data$Store == input$stores) 
    s = input$table_rows_selected
    t = data[s, 1]
    if (length(t)) {
      cat('Please Enter The MPESA Payment Code For:')
      cat(t, sep = ', ')
    }
  })
  
  observeEvent(input$verify, { output$mpesaconfirmation = renderPrint({
    req(input$table_rows_selected)
    req(input$verify)
    con <- DBI::dbConnect(odbc::odbc(),
                          driver = "MySQL ODBC 8.0 Unicode Driver",
                          database = "test_db",
                          UID    = "root",
                          PWD    = "Purity@8",
                          host = "localhost",
                          port = 3306)

    rs <- dbSendQuery(con, "SELECT * FROM customer_data")
    data <- dbFetch(rs)
    data <- filter(data, data$Store == input$stores)
    s = input$table_rows_selected
    t = data[s, 3]
    if (input$mpesacon != t) {
      cat('SORRY THE CODES DO NOT MATCH')

    }
    else{cat('THE CODES MATCH')}
  })})
 
  
observeEvent(input$verify,{
  req(input$mpesacon)
  con <- DBI::dbConnect(odbc::odbc(),
                        driver = "MySQL ODBC 8.0 Unicode Driver",
                        database = "test_db",
                        UID    = "root",
                        PWD    = "Purity@8",
                        host = "localhost",
                        port = 3306)
  
  rs <- dbSendQuery(con, "SELECT * FROM customer_data")
  data <- dbFetch(rs)
  data <- filter(data, data$Store == input$stores)
  a = input$table_rows_selected
  b = data[a, 3]
  c = data[a, 1]
  if(input$mpesacon == b){
    # dbGetQuery(con, statement = 
    #              paste0("
    #             UPDATE customer_data
    #             SET Status = ","Picked","
    #             WHERE `Phone Number` = ","705098186",""))
    dbGetQuery(con,
               paste0("UPDATE customer_data
                       SET Status = 'Picked'
                       WHERE `Phone Number` = ",b,""))
    


 }
  dataTableProxy('table')})

observeEvent(input$refresh,{ 
  con <- DBI::dbConnect(odbc::odbc(),
                        driver = "MySQL ODBC 8.0 Unicode Driver",
                        database = "test_db",
                        UID    = "root",
                        PWD    = "Purity@8",
                        host = "localhost",
                        port = 3306)
  
  rs <- dbSendQuery(con, "SELECT * FROM customer_data")
  data <- dbFetch(rs)
  data <- filter(data, data$Store == input$stores)
  dataTableProxy('table')
 
})
  
  observeEvent(input$first,{
  output$first_name <- renderText({
    print(paste0("First Name: ",  input$first))
  })})
  output$second_name <- renderText({
    print(paste0("Second Name: ",  input$last))
  })
   
  output$store_name <- renderText({
    print(paste0("Store Name: ",input$stores1))
  })
  
  output$phone_number <- renderText({
    print(paste0("Phone Number: ",  input$numbers))
  })
  
  output$item_desc <- renderText({
    print(paste0("Item Description: ",input$description))
  })
  
  output$item_quantity<- renderText({
    print(paste0("Number Of Items: ",  input$quantity))
  })
  
  output$mpesa_code <- renderText({
    print(paste0("MPESA Code: ",  input$mpesa))
  })
  output$confirmation_text<- renderText({
    print(paste0("Please Confirm That The Detail Provided Above Are Correct Before Pressing The Submit Button"))
  })
  
  
  
  
  
}