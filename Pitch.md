The Energy Simulator application
========================================================
author: Anders Spur Hansen
date: March 22nd 2018
font-family: 'Tahoma'
width: 1440
height: 900

<style>
.small-code pre code {
  font-size: 1em;
}
</style>

What is the Energy Simualtor?
========================================================

Welcome to the Energy Consumption Simulator. This data analytics product allows you to perform simulations of energy consumption for a specific household. The app allows you to directly control a series of climate variables like temperature and see the effect on the energy consumption in the household.

The model behind the product is based on a multivariate regression algorithm. The model is trained on one year of energy-  and weather data from Denmark. The resulting model has an accuracy above 80 % on its predictions. 

The application can be found and tested on [Shinyapp.io](https://spurdk.shinyapps.io/EnergySimulator/)


The Data
========================================================
class: small-code


The dataset used for this application is based on one year of collected data for a specific household in Denmark. For each hour the consumed electricity, ambient temperature, wind speed and wind direction is measured. The data is aggregated to daily level. The list below shows a summary of the dataset:


```r
summary(tsEnergy)
```

```
      Date               meanTemp        sumEnergy         meanWind     
 Min.   :2017-03-16   Min.   :-7.167   Min.   : 2.935   Min.   :0.6481  
 1st Qu.:2017-06-11   1st Qu.: 3.583   1st Qu.:14.425   1st Qu.:2.9514  
 Median :2017-09-06   Median : 8.792   Median :25.100   Median :4.1898  
 Mean   :2017-09-06   Mean   : 8.722   Mean   :24.677   Mean   :4.4038  
 3rd Qu.:2017-12-03   3rd Qu.:14.250   3rd Qu.:33.371   3rd Qu.:5.6944  
 Max.   :2018-02-28   Max.   :19.375   Max.   :62.301   Max.   :9.6759  
 meanWindDirection
 Min.   : 23.75   
 1st Qu.:163.53   
 Median :221.71   
 Mean   :209.26   
 3rd Qu.:267.08   
 Max.   :347.25   
```


Regression
========================================================
class: small-code

The model is based on a regression algorithm with the energy consumption as the dependent variable and the temperature, wind speed and wind direction as independent variables.

```r
regModel <- lm(sumEnergy ~ meanTemp + meanWind + meanWindDirection, data = tsEnergy)
summary(regModel)
```

```

Call:
lm(formula = sumEnergy ~ meanTemp + meanWind + meanWindDirection, 
    data = tsEnergy)

Residuals:
    Min      1Q  Median      3Q     Max 
-15.119  -3.387   0.149   3.539  18.873 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)       37.413875   1.071311  34.923  < 2e-16 ***
meanTemp          -1.684417   0.046884 -35.928  < 2e-16 ***
meanWind           0.761550   0.153367   4.966 1.08e-06 ***
meanWindDirection -0.006684   0.004166  -1.605     0.11    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 5.209 on 345 degrees of freedom
Multiple R-squared:  0.8022,	Adjusted R-squared:  0.8005 
F-statistic: 466.5 on 3 and 345 DF,  p-value: < 2.2e-16
```


Prediction
========================================================
class: small-code
When the model is trained we can start making predictions in this

- Temperature: 7.8 degrees of celsius
- Wind speed: 5.4 m/s
- Wind direction: 270 degrees (W)

```r
# Create a new input dataset 
newData <- data.frame(meanTemp = 7.8, meanWind = 5.4, meanWindDirection = 270)

# Perform the prediction
forecastedEnergy <- round(predict(regModel, newData), 2)

print(forecastedEnergy)
```

```
    1 
26.58 
```
Based on these inputs the model predicts a mean hourly energy consumption of 26.58 kWh. 
To try more configurations please visit [The Energy Simualtor](https://spurdk.shinyapps.io/EnergySimulator/)
