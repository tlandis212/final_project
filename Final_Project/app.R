#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- navbarPage(
    "Effect of Absentee Voting on Future Electoral Participation",
    tabPanel("Model",
             fluidPage(
                 titlePanel("Regression Table"),
                 DT::dataTableOutput("table"))),
    tabPanel("Discussion",
             fluidPage(
                 verticalLayout(
                     titlePanel("General Election Turnout Among Voters in North Carolina Who Turned 18 and Voted for the First Time in 2012"),
                     p("This chart is a work in progress"),
                     plotOutput("plot1"),
                     wellPanel(
                         sliderInput("n", "Year", 2012, 2018,
                                      step = 2, value = 2012))))),
             
    tabPanel("About", 
             titlePanel("About"),
             h3("Project Background and Motivations"),
             p("For my project, I am looking at the effect first-time voting type has on future voting behaviors. If someone's first possible vote (i.e. the first possible election they can vote in after they turn 18), is cast through an absentee ballot, does that affect their likelihood of voting in future elections?"),
             h3("About Me"),
             p("This project is completed by Liz Hoveland and Teddy Landis.")))

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$plot1 <- renderPlot({
        # generate x based on input$n from ui.R
        # How do I get perc_treatment to change?
        
        ggplot(data = treatment_outcomes, aes(x = input$n, y= perc_treatment, fill = treatment)) + 
            geom_bar(stat = "identity", position = position_dodge())
    
        })
    
    output$table <- DT::renderDataTable(DT::datatable({
        data <- regression_table
        data
    }))
        
}

# Run the application 
shinyApp(ui = ui, server = server)
