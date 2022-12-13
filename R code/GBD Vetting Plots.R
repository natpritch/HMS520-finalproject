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
library(RColorBrewer)
library(ggplot2)
library(data.table)
library(dplyr)
library(tidyverse)
library(ggforce)
theme_set(theme_bw(16))


##########################################
#Options for user to select
##########################################

cause <- "cervical cancer" #select cause to include in plots
sex <- 1 #select sexes needed for plots
age_groups <- c(5:21) #specify which age groups to include in plots
countries <- c("Colombia", "Costa Rica") #each country will be a page of the plot
years <- c(1990:2015) #select years to include

###################################
#Make dataset
###################################

dat <- read.csv("dataset/gbd vetting plots.csv")
dat$sex <- 2

##################################
#Plotting specific variables (could be defined above or another variable in dataset
#as appropriate for plot aesthetics)
##################################
x_var <- dat$year_id
y_var <- dat$g_code
color_var <-  dat$age_group_id
shape_var <- dat$data_type

###################################
## Set up Main Functions - still original example
##################################

#make ploting function
plotting_fct <- function(tbl, cause='cause'){
  print(ggplot(dat) +
          geom_point(aes(x=x_var, y=y_var, color=color_var, shape=shape_var)) +
          facet_wrap_paginate(~countries, ncol = 1, nrow = 1, scales = "free", page = i))
}


#test plotting function for one country
plotting_fct(tbl = dat)


#make a list to loop over
n <- length(unique(dat$country_id))


#test printing pdf of multiple country plots using for loop
pdf(("garbage_code_qa.pdf"), width = 20, height = 16)
for(i in 1:n){
  plotting_fct(tbl = dat)
}
dev.off()
