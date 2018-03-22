library(plotly)
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Energy Consumption Simulator"),
  h4('Welcome to the Energy Consumption Simulator. This data analytics product allows you to perform simulations of energy consumption for a specific household. The app allows you to directly control a series of climate variables like temperature and see the effect on the energy consumption in the household.'),
  h4('The model behind the product is based on a multivariate regression algorithm. The model is trained on one year of energy-  and weather data from Denmark. The resulting model has an accuracy above 80 % on its predictions.'),
  h4('Please try out the simulator be controlling the input variables in the sidebar and see the immediate effect on the energy consumption. Enjoy, and learn…     '),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       h4('The temperature has a big impact on the household, as it\'s heated by electricity. So please select an ambient temperature:'),
       sliderInput("temperatureSlider",
                   "Temperature in Celsius:",
                   min = 1,
                   max = 40,
                   value = 17),
       h4('The speed of the wind can increase the cooling effect on a household, where higher wind speed has bigger effect. Please select wnd speed:'),
       sliderInput("windSpeedSlider",
                   "Wind speed in m/s:",
                   min = 0,
                   max = 32,
                   value = 12),
       h4('Certain wind directions can have effect on households, due to it construction. Please select a wind direction between 0 and 359 degrees'),
       sliderInput("windDirectionSlider",
                   "Windirection in degrees:",
                   min = 0,
                   max = 359,
                   value = 270)
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      h3('Selected values:'),
      textOutput("selectedTemperatureText"),
      textOutput("selectedWindSpeedText"),
      textOutput("selectedWindDirectionText"),
      
      h3(
      textOutput("energyForecastText")),
      plotlyOutput("forecastGauge")
    )
  )
))
