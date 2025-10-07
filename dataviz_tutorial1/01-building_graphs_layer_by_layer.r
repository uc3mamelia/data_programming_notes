# For this tutorial, we need these packages (run the following to install them 
# if you don’t have them already):
# install.packages("ggplot2")
# In this tutorial, we will mostly use one data set that is bundled with 
# ggplot2: mpg. It includes information about the fuel economy of popular car 
# models in 1999 and 2008, collected by the US Environmental Protection Agency.

library(ggplot2)
mpg

# The variables are mostly self-explanatory:
  
# cty and hwy record miles per gallon (mpg) for city and highway driving.
# displ is the engine displacement in litres.
# drv is the drivetrain: front wheel (f), rear wheel (r) or four wheel (4).
# model is the model of car. There are 38 models, selected because they had a 
# new edition every year between 1999 and 2008.
# class is a categorical variable describing the “type” of car: two seater, SUV, compact, etc.