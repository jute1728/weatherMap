require(shiny)

shinyUI(pageWithSidebar(
    headerPanel("Severe weather in the US"),

  
        sidebarPanel(
            helpText(paste(
                "This app displays the impact of severe weather events in the US in the period 1996 thru 2011"
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
                condition = "input.tab == 'Map'",
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
                     h3(textOutput("maptitle1")),
                     h4(textOutput("maptitle2")),
                     htmlOutput("gvis")  ),
            
            tabPanel("Help",      tabName="Help",  

                     h3("General"),
                     helpText(paste(
                         "There are 2 tabs. The first contains a boxplot summarizing the total impact "
                         , "of different types of weather. The second is a map showing the "
                         , "impact per state of the US."
                     )),

                     h3("Drop down options"),
                     
                     helpText(paste(
                         "By default the numbers are fatalities for "
                         , "all types of weather. This can be altered "
                         , "by choising different options in the drop down "
                         , "boxes in the left hand panel."
                     ))
            )
            
        )
    )    
    
))

