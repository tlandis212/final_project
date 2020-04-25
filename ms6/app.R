#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Milestone 6"),
    
    # Show a plot of the generated distribution
    mainPanel(
        imageOutput("preImage")
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    # Send a pre-rendered image, and don't delete the image after sending it
    output$preImage <- renderImage({
        # When input$n is 3, filename is ./images/image3.jpeg
        filename <- "ms_6.png"
        
        # Return a list containing the filename and alt text
        list(src = filename,
             width = 600,
             height = 371)
        
    }, deleteFile = FALSE)
}

# Run the application 
shinyApp(ui = ui, server = server)