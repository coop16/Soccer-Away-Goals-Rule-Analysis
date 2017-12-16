from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait 

import re
import numpy as np
import pandas as pd
import os
import time


#------------------------------------------------------------------------------#
#Function to get data from a particular year (once already opened the browser)

def getplayoffdata(year):
   
    #Go to correct url for the particular year
    urlname = "https://www.flashscore.com/soccer/usa/mls-%s/results/" % (year)
    browser.get(urlname)
    
    #wait 5 seconds to make sure page has loaded
    time.sleep(5)
        
    #select text body with lines for teams/scores etc.
    gameline = browser.find_elements_by_css_selector("tbody")
    rawdata=[t.text for t in gameline]


    '''
    Select the games we want from each year
    
    STEPS:
    >restrict to rounds with 2-game series, which varies by year
        >2003-2010: only quarterfinal (cut out Final and Semis) 
        >2011: only quarterfinal (cut out Final, Semis and 1/8 Finals)
        >2012-2017: quarterfinal and semis (cut out Final, 1/8 Finals)
    >Some years include the all star game (which we want to ignore)
    >split based on each line
    
    >remove line for round and date so only left with teams and scores
    >use ordering to define columns for home team, away team, home score and away score

    '''
    if year<=2010:
        playoffs= rawdata[0].split("Quarter")[1].split("\n")
    elif year==2011:
        playoffs= rawdata[0].split("Quarter")[1].split("1/8")[0].split("\n")
    else:
        playoffs= rawdata[0].split("Semi")[1].split("1/8")[0].split("\n")
    
    '''    
    Clean data: 
    
    Remove lines with:
        >game dates (will have a ".")
        >round title (will have "finals") 
        >score at end of regulation for overtime games (will have "(" )        
    Remove spaces in strings
    Split score (in format "homegoals:awaygoals") into two sepparate strings
    '''
    playoffs_cleaned=[]
    for i in playoffs:
        if "." not in i and "finals" not in i and "(" not in i:
                if ":" in i:
                    playoffs_cleaned.append(i.split(":")[0].replace(" ","") )
                    playoffs_cleaned.append(i.split(":")[1].replace(" ",""))
                else:
                    playoffs_cleaned.append( i.replace(" ","") )
                    
    #Create dataframe
    df_playoff=pd.DataFrame(data=[ playoffs_cleaned[0::4], 
                                   playoffs_cleaned[1::4],
                                   playoffs_cleaned[2::4],
                                   playoffs_cleaned[3::4]
                                   ])  
    df_playoff=pd.DataFrame(data=df_playoff.transpose()).dropna()
    df_playoff.columns = ["hometeam","awayteam","homegoals","awaygoals"]                               
    
    '''
    Define other variables 
        >based on scores in the dataframe and format/order of entries
    '''
    
    #number of games (8 if only quarterfinals, 12 if quarterfinals and semis)
    numplayoffgames=len(df_playoff)
    
    #Year
    df_playoff["year"] = [year]*numplayoffgames
    
    #Round and leg (use fact that all 1st legs are played before 2nd legs)
    if numplayoffgames==8:
        df_playoff["round"] = ["Quarter"]*8 
        df_playoff["leg1"] = [False]*4+[True]*4
        df_playoff["leg2"] = [True]*4+[False]*4
    else:        
        df_playoff["round"] = ["Semi"]*4+["Quarter"]*8 
        df_playoff["leg1"] = [False]*2+[True]*2+[False]*4+[True]*4
        df_playoff["leg2"] = [True]*2+[False]*2+[True]*4+[False]*4
        
    #High/Low seed goals (use fact that low seed is home team for first leg)
    df_playoff["highseedgoals"] = df_playoff["homegoals"]*df_playoff["leg2"] + df_playoff["awaygoals"]*df_playoff["leg1"]
    df_playoff["lowseedgoals"] = df_playoff["homegoals"]*df_playoff["leg1"] + df_playoff["awaygoals"]*df_playoff["leg2"]
    
    '''
    Create a unique matchup identifier for each pair 
    
    NOTES:
        >leg 1 games played before leg 2, but series order within legs varies
        >We will assign the leg 2 series with an id
        >leg 1 id's will be matched with leg 2 based on teams playing (but with home and away flipped)
        
    '''
    
    #define id for leg2 (leg1 kept NA)
    if numplayoffgames==8:
        seriesid = ["%sq1" % (year),"%sq2" % (year),"%sq3" % (year),"%sq4" % (year)]+[np.nan]*4
    else: 
        seriesid = ["%ss1" % (year),"%ss2" % (year)]+[np.nan]*2+["%sq1" % (year),"%sq2" % (year),"%sq3" % (year),"%sq4" % (year)]+[np.nan]*4

    #Fill run loop through and fill in leg 1 games matching series id with leg 2        
    for i in range(numplayoffgames):
        if pd.isnull(seriesid[i]):
            for j in range(numplayoffgames):
                if  df_playoff["hometeam"][i]==df_playoff["awayteam"][j] and \
                    df_playoff["awayteam"][i]==df_playoff["hometeam"][j]:
                        seriesid[i]=seriesid[j]
    #add to dataframe                    
    df_playoff["seriesid"]=seriesid

    return df_playoff
    
#------------------------------------------------------------------------------#
    
#set relative working directory to open chromedriver.exe later on
filepath = os.path.realpath(__file__)
filedirectory, filename = os.path.split(filepath)
os.chdir( filedirectory )


#Open browser    
browser = webdriver.Chrome("chromedriver.exe")

#create blank dataframe to add data to
df = pd.DataFrame()

#get data for each year and combine into single dataset

#list of all years
yearslist = [2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017]

for year in yearslist:
    
    #get data for year
    yeardat = getplayoffdata(year)

    #print year to see progress
    print(year)
    
    #combine with data from other years
    df = pd.concat([df,yeardat])
 
#save to csv
df.to_csv("playoff.csv",index=False)

#exit browser
browser.quit()
        