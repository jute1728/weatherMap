require(shiny)

shinyUI(pageWithSidebar(
    headerPanel("Severe weather in the US"),

  
        sidebarPanel(
            helpText(paste(
                "This app display the impact of of severe weather events in the US in the period 1996 thru 2011"
                , "The data is from the US NOAA storm database."
                )),
            
             img(src='Tornado.bmp', align = "left", width = "280px"),

            hr(),
            hr(),

            selectInput("var", label = "Choose a variable to display", 
                        choices = list("fatalities"              = "fatalities",
                                       "injuries"               = "injuries" ,
                                       "Crop damage ($1M)"       = "crop.damage" ,
                                       "Property damage ($1M)"  = "prop.damage"   ),
                        selected = "fatalities"
            ),
            
           conditionalPanel(
                condition = "input.tab != 'Overview'",
                selectInput("type", label = "Choose a weather type", 
                        choices = list("<ALL>",
                                       "COLD","DRY","FLOOD","HEAT","HURRICANE","LIGHTNING",
                                       "SEA","SNOW", "STORM","TORNADO","WIND",
                                       "<OTHER>"="OTHER"),
                        selected = "<ALL>"
                )
            )
 
        ),

    mainPanel(
        tabsetPanel(type = "tabs", id="tab",
            tabPanel("Overview", tabName="Main", plotOutput("ggtotals")), 
            tabPanel("Map",      tabName="Map",  
                     verbatimTextOutput("maptitle1"),
                     verbatimTextOutput("maptitle2"),
                     htmlOutput("gvis")  )
        )
    )    
    
))

