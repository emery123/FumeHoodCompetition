The Competition R Script is a framework to start creating graphics for Fume Hood Competitions from Building Automation System Data pulls.

- View the CSV file (Oct09833Hoods1.csv) to compare the data structure to what you have pulled from your BAS

- The data was pulled from a Talon BAS for the Month of October to date (Oct. 18th) for 16 different hoods in 4 seperate labs

- Before running the R script, the column headers were renamed as shown in the CSV provided to simplify the code process.  

- Using the R Script with the sample .CSV provided, the code should run through and provide graphics in the GG plot which are ready to export.

- The most important things to maintain reproducibility are to make sure the column headers in your .CSV match the column header names in R; starting on line 51
	- R automatically adds an 'X' to column headers that begin with a number; this is represented in the R script and you will notice it when importing the data

- If you have differing numbers of labs or hoods this will cause you to need to make greater changes to the inital R script. Email me if you have issues and I may be able to help

- The benefit of this process is once the code is set up to fit the needs of your labs who will be part of the competition,
it is very easily reproducible to give updates to the labs, as well as to repeat on an annual basis.

- the code (line 85) will also write a new .CSV which is the data filtered for night time and the average for each lab. - this is useful to be able to determine percentages and changes
between dates; after initiaion of competition for example. - This is because I haven't been able to create averages within the R script for individual labs yet by subsetting certain dates.


Known Problems

- Ideally, weekends should be entirely counted, not just nights. I can't figure out how to do this simply.
- I would like to be able to create the averages within the RStudio environment but currently this easier in Excel with the NightComp1.csv output 
- I would like to have this not only simply filter out the daytime, but instead filter out openings that are less than ~3 hours which which differentiate between 
actual research and negligence in the hood.