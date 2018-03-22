
library(shiny)
library(plotly)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # setwd("C:/Courses/Developing Data Products/FinalAssignment/EnergySimulator")
  
  # Load data into memory
  weatherData = read.csv("Data/WeatherData.csv", stringsAsFactors = FALSE)
  energyData <- read.csv("Data/EnergyData.csv", sep = ";", stringsAsFactors = FALSE)
  
  # Define date variable from hourly timestamps
  weatherData$Date <-  as.Date(weatherData$Timestamp, "%Y-%m-%d")
  energyData$Date <-  as.Date(energyData$StartTime, "%d-%m-%Y")
  
  # Convert wind speed into m/s
  weatherData$WindSpeed <- (weatherData$WindSpeed * 1000) / 3600
  
  # Agggregate daily values to get mean and sum values for input parameters
  meanTempData <- weatherData %>% group_by(Date) %>% summarise(meanTemp = mean(Temperature, na.rm = T))
  sumEnergyData <-  energyData %>% group_by(Date) %>% summarise(sumEnergy = sum(Value, na.rm = T)) 
  meanWindyData <-  weatherData %>% group_by(Date) %>% summarise(meanWind = mean(WindSpeed, na.rm = T)) 
  meanWindDirectionData <-  weatherData %>% group_by(Date) %>% summarise(meanWindDirection = mean(WindDirection, na.rm = T)) 
  
  # Merege energy and weather data into one dataset
  tsEnergy <- merge(meanTempData, sumEnergyData)
  tsEnergy <- merge(tsEnergy, meanWindyData)
  tsEnergy <- merge(tsEnergy, meanWindDirectionData)
  
  # Create multivariate regression model
  regModel <- lm(sumEnergy ~ meanTemp + meanWind + meanWindDirection, data = tsEnergy)

  # Write out the selected input values
  output$selectedTemperatureText <- renderText(paste('Temperature: ', input$temperatureSlider, ' C.'))
  output$selectedWindSpeedText <- renderText(paste('Wind speed: ', input$windSpeedSlider, 'm/s'))
  output$selectedWindDirectionText <- renderText(paste('Wind direction: ', input$windDirectionSlider))
  
  # REACTIVE FUNCTIONS
  # -------------------------------------------------------------------------
  
  # Predict new energy consumption based on updated inputs
  forecast <- reactive({
    
    # Get new inputs
    meanTemp <- input$temperatureSlider
    meanWind <- input$windSpeedSlider
    meanWindDir <- input$windDirectionSlider
    
    # Define input data.frame for lm.predict function
    features <- data.frame(meanTemp = meanTemp, 
                           meanWind = meanWind,
                           meanWindDirection = meanWindDir)
    
    # Make the prediction based on the model
    kwh <- predict(regModel, newdata = features)
    
    # This household has an always-on value of 5 kWh per hour
    if(kwh < 5) { kwh <- 5}
    
    # Round the values to 1 decimal
    round(kwh, 1)
    
  })
  
  # Update the UI with energy consumption
  output$energyForecastText <- renderText({
    paste('Predicted energy consumption: ', forecast(), ' kWh per hour')
  })
  
  
  # Generate bar chart using plotly
  output$forecastGauge <- renderPlotly({
    
    x <- as.numeric(forecast())
   
    p <- plot_ly(
      x = c("Energy Consumption in kWh per hour"),
      y = x,
      name = 'ECChart',
      type = "bar"
    ) %>%
      layout(
        yaxis = list(range = c(0, 60)))
    
    p
    
  })
})
