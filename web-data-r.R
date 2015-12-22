library(shiny)
library(RCurl)
# sudo apt-get install libcurl4-gnutls-dev
# Cannot find curl-config in Ubuntu 13.04

ui <- fluidPage(
  sidebarPanel(
    selectInput("country", "Variable:",
                list("Korea" = "KOR", 
                     "Canada" = "CAN", 
                     "Japan" = "JAPAN"))
  ), 
  plotOutput("hist")
)

server <- function(input, output) {
  
  formulaText <- reactive({
    paste0('http://climatedataapi.worldbank.org/climateweb/rest/v1/country/cru/tas/year/',input$country, '.csv')
  })
  
  output$hist <- renderPlot({
    tmp.dat <- getURL(formulaText())
    rslt <- read.csv(textConnection(tmp.dat))
    plot(rslt[,1],rslt[,2], xlab="Year", ylab="Avg. Temperature")
  })
}

shinyApp(ui = ui, server = server)