
## Install Packages (only need to do one time) ##
install.packages("ggplot2")
install.packages("lubridate")
install.packages("tidyr")
install.packages("tibble")
install.packages("dplyr")
install.packages('Cairo')

## Load packages into your environment - every time ##
library(ggplot2) #plotting library
library(lubridate) #handles date formats well
library(tidyr)
library(tibble)
library(tidyverse)
library(dplyr) #data management library
library(Cairo) #makes the graphs smoother

## Make sure you set your working directory to the location where your .csv dataset is - Session -> Set working directory 

### Organizing data ###
# importing the df #
data1 <- read.csv("Oct09133Hoods1.csv", header = T, stringsAsFactors = F)


# converting the time column into an R-time datatype #
data1$time <- dmy_hms(data1$time)


# creating a tibble #
data2 <- as.tibble(data1)


# Splitting date from time of day #
data2$date <- as.Date(data2$time) 
data2$time2 <- format(data2$time, "%H:%M:%S")


# Filtering the daytime values to only look at night - 8pm to 8am #
data4 <- data2 %>%
  filter( time2 > "20:00")
data5 <- data2 %>%
  filter( time2 < "08:00")


# Binding back the morning data to night data #
Nightdata <- rbind(data4, data5)


# Splitting each Lab into its own df - 4 hoods per lab #
df3356 <-  Nightdata  %>% 
  select( X3356A, X3356B, X3356C, X3356D)
df3354 <- Nightdata %>%
  select(X3354A, X3354B, X3354C, X3354D)
df3346 <- Nightdata %>%
  select(X3346A, X3346B, X3346C, X3346D)
df3336 <- Nightdata %>%
  select(X3336A, X3336B, X3336C, X3336D)


#averaging the 4 fume hoods per lab into a single average
df3356$avg3356 <- rowMeans(df3356)
df3354$avg3354 <- rowMeans(df3354)
df3346$avg3346 <- rowMeans(df3346)
df3336$avg3336 <- rowMeans(df3336)


#binding the dataframes of each lab back together 
dfAVG <- as.data.frame(cbind("avg3356" = df3356$avg3356, "avg3354" = df3354$avg3354, "avg3346" = df3346$avg3346, "avg3336" = df3336$avg3336))
dfAVG2 <- cbind(dfAVG,  Nightdata$time )

## Rename the labs from their building location to PI name ##
dfAVG2$Issacs_Lab <- dfAVG2$avg3336
dfAVG2$Davis_Lab <- dfAVG2$avg3346
dfAVG2$Gutierrez_Lab <- dfAVG2$avg3354
dfAVG2$Falvey_Lab <- dfAVG2$avg3356

# Gathering data to create "Tidy Data" # 
dfAVG3 <- dfAVG2 %>%
  gather("Issacs_Lab", 'Davis_Lab', 'Gutierrez_Lab', 'Falvey_Lab', key = "lab", value = "avg")
dfAVG3$time <- dfAVG3$`Nightdata$time`
dfAVG2$time <- dfAVG2$`Nightdata$time`

## writing out a CSV to view later, and pull out averages easier than in R writes to your workind directory ##
write.csv(dfAVG2, file = "NightComp1.csv")

## Use this to specify a vertical line, the date the competition began -
## you need to view dfAVG3 and determine which line number corresponds to the date you started the comp. Oct. 9 in this case; corresponding to [478]
date_line <- (dfAVG3$time[574])


#This line is optional - gives better looking plots, while making exporting more difficult. 
CairoWin()

## Charts Average Fume Hood Position for Each lab over time, Auto regression function ##
ggplot(dfAVG3, aes(x = time, y = avg, color = lab))+
  geom_vline(aes(xintercept=date_line), size = 2) +
  geom_line(size = 1.2) +
  theme_bw() +
  labs(x = "October", y = "Average Sash Percent Open", subtitle = "091-3-3XX Labs : 16 Hoods in 4 Labs - Black line indicates Competition Beginning", title = "Average Fume Hood Sash Height") +
  theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) +
  geom_smooth(method = "auto", alpha = 0.2, size = 1) +
  ylim(0, 60)


## Charts Average Fume Hood Position for All Hoods, auto regression function ##
ggplot(dfAVG2, aes(x = time, y = avg3356)) + 
  geom_vline(aes(xintercept=date_line), size = 2) +
  geom_line(size = 1) +
  theme_bw() +
  labs(x = "October", y = "Average Percent Open", subtitle = "091-3-3XX Labs", title = "Average Fume Hood Sash Height") +
  theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) +
  geom_smooth(method = "auto", alpha = 0.1)+
  ylim(0, 60)


