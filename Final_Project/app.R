#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(ggplot2)

# Load in data that is a tibble ready to work with (i.e. "treatment_outcomes)
# write_rds to save a table to rds

# Put this in my other scripts
# write_rds(treatment_outcomes, "Final_Project/treatment_outcomes.rds")

# Load in treatment_outcomes for plot1

treatment_outcomes <- read_rds("raw-data/treatment_outcomes.rds")

# Load in regression_table for regression table

regression_table <- read_rds("raw-data/regression_table.rds")





# Define UI for application that draws a histogram
ui <- navbarPage(
    "Effect of Absentee Voting on Future Electoral Participation",
    tabPanel("Discussion",
             fluidPage(
                 h2("Our Question"),
                 p("Does the experience of voting for the first time have an effect on future participation in elections? Every year millions of young people cast a ballot for the first time. Many do it at the polls, like most Americans, but many vote using an absentee ballot. In line with previous research on voting and habit formation, we hypothesize that the actual, in-person experience of casting your first ballot (and recieving a sticker, taking a selfie, and potentially celebrating with peers) could be more impactful in terms of habit formation, than the dull process of filling out an absentee ballot. By looking at first-time voters in North Carolina, we will see if voting absentee-by-mail has a negative effect on future participation compared to those who vote in-person."),
                 h2("Our Sample"),
                 p("For this study, we used the North Carolina record of registered voters and the record of voter history to create a sample of voters that met the following criteria:"),
                 tags$ul(
                     tags$li("Turned 18 in 2012"), 
                     tags$li("Registered to vote in 2012"), 
                     tags$li("Cast a ballot in 2012")),
                 p("Within this universe, we assigned voters that used a mail-in absentee ballot in 2012 to our treatment group and all other voters to the control group. (Voters in the control group cast ballots through a variety of means, such as early voting, but all required in-person activity."),
                 p("We then tracked this cohort's participation in the 2014 midterm, 2016 presidential, and 2018 midterm elections."),
                 verticalLayout(
                     titlePanel("First-Time Absentee Voters Participated in Most Future Elections at Higher Rates"),
                     plotOutput("plot1"),
                     wellPanel(
                         sliderInput("n", "Year", 2012, 2018,
                                      step = 2, value = 2012, animate = TRUE))),
                 p("We find that voters who cast a ballot by mail-in absentee in 2012, participated in the 2016 and 2018 elections at a higher rate compared to the control group and participated in the 2014 midterm election similar rates"),
                 h2("Implications"),
                 p("Our intention was to determine whether a first-time voters' voting experience has an effect of future participation. We hypothesized that if it does have an effect, we'd see higher future participation among those who voted in-person. These findings dispute this hypothesis, but also reveal the flaws in our experimental study. While voters who cast a ballot using an absentee mail-in process voted at higher rates in 2016, and 2018, there is not a likely causal relationship. Instead, there are probably intervening variables causing this correlation. One may be that an 18 year old in college is more likely to vote by mail and we know that college-educated people vote at higher rates; therefore it makes sense that if a college student is more likely to cast a ballot by mail, they are also more likely to vote."),
                 p("In a more complete version of this study, we would want to control for education, race, class, and physical ability (Can a voter physically go to the polls or are there impeding health challenges?), to see if first-time voting experience does have an effect on future electoral participation. To do this, we would need to look beyond the North Carolina Voter File, which includes no demographic data beyond race."))),
    tabPanel("Model",
             fluidPage(
                 titlePanel("Regression Table"),
                 DT::dataTableOutput("table"))),         
    tabPanel("About", 
             titlePanel("About"),
             h3("Project Background and Motivations"),
             p("For our project, I am looking at the effect first-time voting type has on future voting behaviors. If someone's first possible vote (i.e. the first possible election they can vote in after they turn 18), is cast through an absentee ballot, does that affect their likelihood of voting in future elections?"),
             h3("About Me"),
             p("This project is completed by Liz Hoveland and Teddy Landis.")))

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$plot1 <- renderPlot({
        # generate x based on input$n from ui.R
        # How do I get perc_treatment to change?
        
        
        treatment_outcomes %>% 
            filter(year == input$n) %>% 
            ggplot(aes(x = year, y= perc_treatment, fill = treatment)) + 
            geom_bar(stat = "identity", position = position_dodge()) +
            ylim(0, 100) +
            theme_classic() +
            labs(title = "General Election Turnout Among Voters in North Carolina\nWho Turned 18 and Voted for the First Time in 2012",
                 subtitle = "Voters whose first ballots were cast by Absentee Ballots are in the Treatment group",
                 x = "Year",
                 y = "Percent that Cast Ballots",
                 caption = "Our sample is defined as people who turned 18 in 2012, registered to vote in 2012,\nand cast a ballot in 2012, so 100% of both our treatment and control groups voted\n in the 2012 election.") +
            geom_text(aes(label = perc_treatment), position = position_dodge(.9), vjust = 2) +
            scale_fill_discrete(name = "Treatment Group", labels = c("Control (In-Person in 2012)", "Treatment (Absentee in 2012)"))
    
        })
    
    output$table <- DT::renderDataTable(DT::datatable({
        data <- regression_table
        data
    }))
        
}

# Run the application 
shinyApp(ui = ui, server = server)
