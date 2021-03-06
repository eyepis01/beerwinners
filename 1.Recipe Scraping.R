### The Beer Winners
#   We are importing ingredients from the YummlyR API
#   We are then clustering the recipes based on ingredients to see if 
#     clusters line up with cuisine names 
#   We are also going to attempt to predict the Cuisine Type based on ingredients using 
#      a Naive Bayes model.
#   We are also going to recluster inside of two clusters that are much too big to be effective. 

library(tidyr)
library(dplyr)
library(yummlyr)
library(stringr)
library(tm)

#set Working Directory
setwd("c:/temp")
#set Seed
set.seed(1234)

### Required credentials for YummlyR API
save_yummly_credentials([Get Your Own Credentials])

### Build a data frame of cuisines
cuisine <- get_metadata("cuisine")

### Build a list of cuisine types
cuisinename<- cuisine[,2]

###!!!###!!!
# NOTE:
# Line 37 often does not run with out error on the first try. This is a problem with the API that YummlyR uses. 
# The end result of this block of code is saved on GitHub as RecipeData.Rda. This is the best way to replicate our results.
# It also ensures that you use the same data as we did due to the fact that the API pulls current records. Our data is from 7/5/2016
###!!!###!!!

### Build a list of 13 thousand recipes
recipes <- lapply(cuisinename, function (x) search_recipes(search_words="", allowed_cuisine=x, max_results = 500))

### Recipes has 26 lists in it, and inside recipes[[i]]$matches$recipeName is the name of the recipe
###                                inside recipes[[i]]$matches$ingredients[j] are the 
###                                                            corresponding ingredients that we need     

### Build a column of recipe titles, This is done because we use loops elsewhere 
### The names for recipes need to be looped for correct consistency
fullrecipes<- as.data.frame(unlist(lapply(recipes, function(x) x$matches$recipeName)))
z<-1
for(i in 1:26){
  list1<-recipes[[i]]
  for(j in 1:500){
    list2<-list1$matches$recipeName[j]
    fullrecipes$recipe[z]<-list2
    z<-z+1
    print(z)
  }
}

### Build a column of ingredients
#fullrecipes$ingredients<- lapply(recipes, function(x) x$matches$ingredients)
### WRONG, that code did not work as intended.
### Lists all ingredients used in the first 400 recipes in the first row, second 400 in row 2,
### Begins repeating at row 27
z<-1
for(i in 1:26){
  list1<-recipes[[i]]
  for(j in 1:500){
    list2<-list1$matches$ingredients[j]
    fullrecipes$ingredients[z]<-list2
    z<-z+1
    print(z)
  }
}

### Build a column of cuisine's
z<-1
for(i in 1:26){
  list1<-recipes[[i]]
  for(j in 1:500){
    list2<-list1$matches$attributes$cuisine[j]
    fullrecipes$cuisine[z]<-list2
    z<-z+1
    print(z)
  }
}

### Drop the results of the apply and remove NA's
fullrecipes<-fullrecipes[,c(2,3,4)]
data <- fullrecipes[!is.na(fullrecipes$recipe),]


### Put ingredients into character form from lists
data$ingredients<-as.character(data$ingredients)
data$recipe<- as.character(data$recipe)
data$cuisine<- as.character(data$cuisine)

### Remove the c(...) from the beginning and end of the lists
data$ingredients<- substring(data$ingredients, 3)
data$ingredients<-gsub("\\)","",data$ingredients)
### Remove spaces
data$ingredients <- gsub(" ","_",data$ingredients)
data$ingredients <- gsub(",_",",",data$ingredients)

### Clean the Cuisine Column
for (i in 1:12982){
  if(substring(data$cuisine[i],1,1)=="c"){
    data$cuisine[i]<- substring(data$cuisine[i], 3)
    data$cuisine[i]<-gsub("\\)","",data$cuisine[i]) 
  }
}
data$cuisine<-gsub("[[:punct:]]", "", data$cuisine)
data$cuisine<-gsub('([A-z]+) .*', '\\1', data$cuisine)

### !!! If you have any errors please download RecipeData.Rda from GitHub 
### !!! The YummlyR API is not always effective at pulling in data with out error.

##########################################################
### Create a backup for redundancy
data1<-data
View(data1)
##########################################################
