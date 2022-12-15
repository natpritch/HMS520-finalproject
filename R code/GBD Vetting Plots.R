##################################################################################
# Name of Script: GBD Vetting Plots.R
# Date: 11/30/2022
# Description:  plot data for selected causes, sexes, age groups, and countries by year
# Arguments: 
#     cause <- list [e.g: "cervical cancer"]
#     sex <- int [e.g: 1]
#     age_groups <- int [e.g: c(5:21)]
#     countries <- list [e.g: c("Colombia", "Costa Rica")]
#     years <- int [e.g: c(1990:2015)]
#      
# How to use: 
#     1)run interactively on Rstudio session
#
# Output: pdf graphs
# Contributors: Natalie Pritchett and Betyna Berice
###################################################################################

#########################
## Set up libraries
#########################
rm(list=ls())
library(MASS)
library(tidyverse)
library(writexl)
library(ggforce)


###################################
#Make dataset
###################################

#create data frame to house character variable cause
cause <- rep("cervical cancer", times=50)

#create random binary data type variable and assign values to 0 and 1
data_type_random <- rbinom(50, 1, .5)
data_type <- ifelse(data_type_random == 0, "VR", "CR")

#create garbage code variable that is between 1 and 100 percent
g_code <- runif(50, 1, 100)

#create country id and countrie varianle and assign values to 0 and 1
country_id <- rbinom(50, 1, .5)
countries <- ifelse(country_id == 0, "Colombia", "Costa Rica")

#create year id with repeating values
year_id <- sample(1990:2015, 50, replace=TRUE)

#create age group id with repeating values
age_group_id <- sample(5:21, 50, replace = TRUE)

# create female only id repeating 50 times
sex_id <-rep(2,times=50)

# combine them into one data fram 
practice <- cbind.data.frame(data_type, g_code, country_id, countries, year_id, age_group_id, sex_id, cause)

#reassign country id to refelct mock gbd location id
practice$country_id[practice$country_id == 0] <- 28
practice$country_id[practice$country_id == 1] <- 27

#export mock data as csv for data manipulation
write_csv(practice, "Final Project.csv")

dat <- practice

##################################
#Options for user to select
##################################
x_var <- dat$year_id
y_var <- dat$g_code
color_var <-  dat$age_group_id
shape_var <- dat$data_type
countries <- c("Colombia", "Costa Rica") #each country will be a page of the plot

###################################
## Set up Main Functions - still original example
##################################

#make ploting function
plotting_fct <- function(tbl, cause='cause'){
  print(ggplot(dat) +
          geom_point(aes(x=x_var, y=y_var, color=color_var, shape=shape_var, size=3)))
}


#test plotting function for one country
plotting_fct(tbl = dat)


#make a list to loop over
n <- length(unique(dat$country_id))


#test printing pdf of multiple country plots using for loop
pdf(("garbage_code_qa.pdf"), width = 20, height = 16)
for(i in 1:n){
  plotting_fct(tbl = dat) +
    facet_wrap_paginate(~countries, ncol = 1, nrow = 1, scales = "free", page = i)
}
dev.off()
