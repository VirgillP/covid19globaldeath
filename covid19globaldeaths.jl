# COVID 19 Global Deaths
# Building a situation graph regarding global deaths due to covid19
# Achieving this graph a time series csv file cab be downloaded from
# John Hopkins' github repository.


# Import all needed packages using the 'using' keyword followed by the package
# name i.e. using Plots.

# IMPORTTANT. To run these packages or any line of code click on the package name
# or line of code and press Shift + Enter once. This will excecute the code.

using Plots
using CSV
using Dates
using Interact
using DataFrames
using PlotThemes
using ORCA


# The COVID-19 Data Repository contains the up to date
# time_series_covid19_deaths_global.csv file which should do the job
# a. Head to the github weblink: https://github.com/CSSEGISandData/COVID-19
# b. Look for the directory named csse_covid_19_data and click once to open it
# c. Then look for the csse_covid_19_time_series directory and click once to open it
# d. The time_series_covid19_deaths_global.csv is the file you will need to work with.
# e. On the right-hand side click on the option Raw
# d. Finallym in the web browser's search bar highlight the webaddress and copy it

# Respecting Julia's naming convention; All variable names, parameters, and
# function names will be in lowercase. Camel casing names should only be used
# if the variable name is be hard to read if its in lowercase.

# Creat a variable named url or any name relevant to your project and
# assign this new varialbe name with the webaddress copied in the previous steps
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/81edec24de608560c4a67d497248a7f658a1fb0b/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"

# Download this csv_covid_19_data file using the download()
# The download function takes two parameter;
# A variable name and a name for the downloaded file
# Note that this csv file will be downloaded in the working directory
# This is where jl extensio file is located
download(url, "csv_covid_19_global_death.csv")

# Lets find out if the file has been downloaded using the function readdir()
# You should see the newly named csv file -> csv_covid_19_global_death.csv
readdir()


# We can assign this downloaded csv file with a variable name which can
# make it more convenient to work with. We can assign it the name data.
# data = CSV.read("csv_covid_19_global_death.csv")
data  = DataFrame(CSV.File("csv_covid_19_global_death.csv"))
data

# After viewing the data, we can rename certain columns
# This may provide a good way to manipulate data with certain columns
globaldata = rename!(data, 1=> "province", 2=>"country")

# After renaming the desired colum(s) we can view the csv file again
globaldata
# We may also need the original data when things goes wrong.
# It is always good practice to make a copy of the original data before
# renaming colum(s). In this instance there is no need to make a copy
# because the original data is readily available on the internet

# The purpose of this project is to demonstrate global death due to the coronavirus
# So lets start extracting data from columns we might need to present our graph with
# We will extract all countries and territories from the column we renamed to country
# and put it in a new variable named countries
countries = globaldata[:,2] # colon means read all rows
                    # and the 2 means the second column
                    # Take note unlike in other languages where
                    # indices start at 0, in Julia indexing start at 1

# Now lets collect these countries and put them gain in the varialbe allcountries
# using the collect();
allcountries = collect(globaldata[:, 2])

# We need the date of death (sadly) and we will use the names() assign it to
# the variable name dates
# Read the Julia documentation about the names()
dates = names(globaldata)

# If we want to see that death rate of a specific conuntry
# we can make use of the function startswith(), lets try South Africa
startswith("South", "S")
# The return type startswith() is a boolean.
# We can take it a step futher by looking up the column country
# filtering out all possible entries that might return a result
# starting with South and assign this to with a new variable name
sa = [startswith(country, "South") for country in allcountries]

globaldata[sa, :] #We will look for all possible fields that starts with South

# Have you noticed in the previous steps that some sort of table is returned
# showing a table? This is achieved with the DataFrames packages, pretty neat!

allcountries .== "South Africa"
# period before == is "broadcasting": apply operation to each element of a vector

# We will now look for the entry South Africa in allcountries and assign it to
# a sadata
sadata = [startswith(country, "South Africa") for country in allcountries]

# findfirst() is able to find South Africa
sadatarow = findfirst(allcountries .== "South Africa")

# Once found we can assign this to southafricadata which is the start to plotting
# our graph
southafricadata = globaldata[sadatarow, :]

# Starting from the 5th column; this is where available data begins
saplot = convert(Vector, southafricadata[5:end])


# After we have the countries and days of death we need to collect
# this data by calling the String() with the confirmed days
# We need to apply the String() to each element
# we will call the days:
confirmeddate = String.(names(globaldata))[5:end]
                                #I noticed the days start from
                                #the 5th colum till the last
#Let see what date we can retrieve  on the first row
confirmeddate[1]


# Notice that the date are formatted as mm/dd/yy
formatdate = Dates.DateFormat("m/d/y")

# We can parse these dates: meaning making the dates which are strings
# into numbers.
# The first argument is the Date() from the Dates package, then we need
# to tell pars() which object we want the Date() to apply to and the format
parse(Date, confirmeddate[1], formatdate) +Year(2000)

# You can assign these dates into a new varialbe name which will form the x-axis
# .+Year() is a way to fill in the year for centuries
deceaseddays = parse.(Date, confirmeddate, formatdate) .+Year(2000)

# Next, we will uses theh GR framwork
# gr is a universal framework for cross-platform visualization applications.
# It represents a 2D x,y graph
gr()

#We will use the keyword plot()and as argument our final plotting variable name
plot(saplot)
plotlyjs()
# We will provide attrributes to our plotting here.
# Read more about these atrributes
defaultplot = plot(deceaseddays, legend=:bottomleft, label="time-line",
     saplot,
     xticks=deceaseddays[1:14:end],
     xrotation=45,
     leg=:topleft,
     grid=false,
     #size=(1200,800)
     )


    scatter!(deceaseddays,
             saplot,
            linewidths=1,
            label="death",
            marker=:o,
            markersize=3,
            markeralpha = 7.0,
            markercolor="brown",
            hover=saplot)
theme(:juno)
xlabel!("Confirmed death every 14 days")
ylabel!("Total deaths")
title!("COVID-19 death")

