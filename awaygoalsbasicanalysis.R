library(ggplot2)
library(reshape2)
library(readr)

#load dataset (already scraped/parsed in python)
setwd("C:/Users/Cooper/OneDrive/Documents/SoccerAwayGoals")
pdat<-read_csv("playoff.csv")




#define some new variables

#total goals
pdat$totalgoals<-pdat$homegoals+pdat$awaygoals
#home goals differential
pdat$homegoaldiff<-pdat$homegoals-pdat$awaygoals
#highseed differential
pdat$highseeddiff<-pdat$highseedgoals-pdat$lowseedgoals



#--------------------------------------------------------------#
# How often do teams win by the away rule?
#--------------------------------------------------------------#

#define dataset of playoff series since away rule put in place in 2014
pdat.a<-pdat[pdat$year>=2014,]
pdat.b<-pdat[pdat$year<2014,]

#Find number to times a series was decided by the away goal rule
#     >the aggregate score was tied
#     >the away goals for each team are not equal

for( j in unique(pdat.a$seriesid) ){
  if(sum(pdat.a$highseedgoals[pdat.a$seriesid==j])==
     sum(pdat.a$lowseedgoals[pdat.a$seriesid==j]) &
     pdat.a$awaygoals[pdat.a$leg1=="True" & pdat.a$seriesid==j] !=
     pdat.a$awaygoals[pdat.a$leg2=="True" & pdat.a$seriesid==j] ){
       print(j)
     }
}
# 3 out of 24 (12.5%) 2-leg series since the introduction of the away goals rule have 
# been decided by the rule

# "2017q3"
# "2014s1"
# "2014q1"

#--------------------------------------------------------------#
# How do the playoff series compare pre- and post-
# introduction of the away goals rule?
#--------------------------------------------------------------#



#--------------------------------------------------------------#
# (a) Average goals scored per game
#--------------------------------------------------------------#

#t test of mean goals scored per game comparing 2 leg games after and before away goals rule implemented
t.test(pdat.a$totalgoals,pdat.b$totalgoals)
#   Since away goals rule:   2.50
#   Before away goals rule:  2.21
#   Mean difference:         0.29 (95% CI: -0.27, 0.85)


#plot of average playoff goals scored in 2 leg playoff series over time
yearlygoals<-by(pdat$totalgoals,pdat$year,mean)
barcols<-ifelse(names(yearlygoals)>=2014,"black","gray")
barplot(yearlygoals,xlab = "Year",col = barcols, ylab="Average Goals Scored per Game", ylim=c(0,3.5), main="All 2-Leg Round Playoff Games")

#Just first leg
yearlygoals2<-by(pdat$totalgoals[pdat$leg1=="True"],pdat$year[pdat$leg1=="True"],mean)
barplot(yearlygoals2,xlab = "Year",col = barcols, ylab="Average Goals Scored per Game", ylim=c(0,3.5), main="Leg 1 of 2-Leg Round Playoff Games")

#Just Second leg
yearlygoals3<-by(pdat$totalgoals[pdat$leg2=="True"],pdat$year[pdat$leg2=="True"],mean)
barplot(yearlygoals3,xlab = "Year",col = barcols, ylab="Average Goals Scored per Game", ylim=c(0,3.5), main="Leg 2 of 2-Leg Round Playoff Games")


#save files to reproduce in D3
tgbyyear<-data.frame(cbind(year=2003:2017,avegoals=round(yearlygoals,digits=2)))
write.csv(tgbyyear,file = "totalgoals.csv",row.names = F)
tgbyyear2<-data.frame(cbind(year=2003:2017,avegoals=round(yearlygoals2,digits=2)))
write.csv(tgbyyear2,file = "totalgoalsleg1.csv",row.names = F)
tgbyyear3<-data.frame(cbind(year=2003:2017,avegoals=round(yearlygoals3,digits=2)))
write.csv(tgbyyear3,file = "totalgoalsleg2.csv",row.names = F)

#--------------------------------------------------------------#
# (b) Average Difference of Home Goals vs. Away Goals scored per game
#--------------------------------------------------------------#

#t test of mean goals differential (home - away) per game comparing 2 leg games after and before away goals rule implemented
t.test(pdat.a$homegoaldiff,pdat.b$homegoaldiff)
#   Since away goals rule:   0.67
#   Before away goals rule:  0.46
#   Mean difference:         0.21 (95% CI: -0.36, 0.78)

#plot of average playoff goal differential (home - away)  scored in 2 leg playoff series over time
yearlygoalsdiff<-by(pdat$homegoaldiff,pdat$year,mean)
barplot(yearlygoalsdiff,xlab = "Year",col = barcols, ylab="Average Goal Differential (Home - Away)", ylim=c(-2,2), main="All 2-Leg Round Playoff Games")

#Just first leg
yearlygoalsdiff2<-by(pdat$homegoaldiff[pdat$leg1=="True"],pdat$year[pdat$leg1=="True"],mean)
barplot(yearlygoalsdiff2,xlab = "Year",col = barcols, ylab="Average Goal Differential (Home - Away)", ylim=c(-2,2), main="Leg 1 of 2-Leg Round Playoff Games")

#Just Second leg
yearlygoalsdiff3<-by(pdat$homegoaldiff[pdat$leg2=="True"],pdat$year[pdat$leg2=="True"],mean)
barplot(yearlygoalsdiff3,xlab = "Year",col = barcols, ylab="Average Goal Differential (Home - Away)", ylim=c(-2,2), main="Leg 2 of 2-Leg Round Playoff Games")


#--------------------------------------------------------------#
# (c) Average Difference of High Seed Goals vs. Low Seed Goals scored per game
#--------------------------------------------------------------#

#t test of mean goals differential (highseed - lowseed) per game comparing 2 leg games after and before away goals rule implemented
t.test(pdat.a$highseeddiff,pdat.b$highseeddiff)
#   Since away goals rule:   0.08
#   Before away goals rule:  0.10
#   Mean difference:         -0.02 (95% CI: -0.63, 0.58)

#plot of average playoff goal differential (home - away)  scored in 2 leg playoff series over time
yearlygoalsdiff<-by(pdat$highseeddiff,pdat$year,mean)
barplot(yearlygoalsdiff,xlab = "Year",col = barcols, ylab="Average Goal Differential (High seed - Low seed)", ylim=c(-2,2), main="All 2-Leg Round Playoff Games")

#Just first leg
yearlygoalsdiff2<-by(pdat$highseeddiff[pdat$leg1=="True"],pdat$year[pdat$leg1=="True"],mean)
barplot(yearlygoalsdiff2,xlab = "Year",col = barcols, ylab="Average Goal Differential (High seed - Low seed)", ylim=c(-2,2), main="Leg 1 of 2-Leg Round Playoff Games")

#Just Second leg
yearlygoalsdiff3<-by(pdat$highseeddiff[pdat$leg2=="True"],pdat$year[pdat$leg2=="True"],mean)
barplot(yearlygoalsdiff3,xlab = "Year",col = barcols, ylab="Average Goal Differential (High seed - Low seed)", ylim=c(-2,2), main="Leg 2 of 2-Leg Round Playoff Games")



#--------------------------------------------------------------#
# (d) Distribution of aggregate scores
#--------------------------------------------------------------#


seriesagg_post<-aggregate(pdat.a[,c("highseedgoals","lowseedgoals","homegoals","awaygoals")],by=list(pdat.a$seriesid),sum)
seriesagg_pre<-aggregate(pdat.b[,c("highseedgoals","lowseedgoals","homegoals","awaygoals")],by=list(pdat.b$seriesid),sum)

#Aggregate scores
seriesagg_post$highseeddiff<-seriesagg_post$highseedgoals-seriesagg_post$lowseedgoals
seriesagg_pre$highseeddiff<-seriesagg_pre$highseedgoals-seriesagg_pre$lowseedgoals

#Distribution (Percentages) of Agregate scores (after rule in place)
aggscore_post<-round(prop.table( table(   factor(seriesagg_post$highseeddiff ,levels = c(-7:5) )  ))*100, digits=1)
barplot(aggscore_post,ylab="Percentage",ylim=c(0,30))

#Distribution (Percentages) of Agregate scores (before rule in place)
aggscore_pre<-round(prop.table(table(  factor(seriesagg_pre$highseeddiff,levels = c(-7:5) )    ))*100, digits=1)
barplot(aggscore_pre,ylab="Percentage",ylim=c(0,30))


#write files to replicate graphs in D3
aggscore_post<-as.data.frame(aggscore_post)
colnames(aggscore_post)<-c("score","percentage")
write.csv(aggscore_post,file = "aggregatescorepost.csv",row.names = F)

aggscore_pre<-as.data.frame(aggscore_pre)
colnames(aggscore_pre)<-c("score","percentage")
write.csv(aggscore_pre,file = "aggregatescorepre.csv",row.names = F)



#--------------------------------------------------------------#
# Heatmaps with ggplot
#--------------------------------------------------------------#

#Group 3+ goals into 3
pdat$awaygoalsgrp<-ifelse(pdat$awaygoals>2,"3+",pdat$awaygoals)
pdat$homegoalsgrp<-ifelse(pdat$homegoals>2,"3+",pdat$homegoals)


#Frequency Tables (%)
ptabl_post = round( prop.table( table(pdat$homegoalsgrp[pdat$year>=2014],pdat$awaygoalsgrp[pdat$year>=2014]) )*100 ,digits=1)
ptabl_pre = round( prop.table( table(pdat$homegoalsgrp[pdat$year<2014],pdat$awaygoalsgrp[pdat$year<2014]) )*100 ,digits=1)


#Postseason Pre-Away goal rule
pmelt_pre<-melt(ptabl_pre)
HomeGoals <- pmelt_pre$Var1
AwayGoals <- pmelt_pre$Var2
Percentage <- pmelt_pre$value
ggplot(pmelt_pre,aes(x=HomeGoals,y=AwayGoals,fill=Percentage)) +
  geom_tile() +
  scale_fill_gradient2(low = "white", high = "red", limit=c(0,20))+ 
  labs(title = "Postseason Goals Prior to Away Goal Rule")

#Postseason Post-Away goal rule
pmelt_post<-melt(ptabl_post)
HomeGoals <- pmelt_post$Var1
AwayGoals <- pmelt_post$Var2
Percentage <- pmelt_post$value
ggplot(pmelt_post,aes(x=HomeGoals,y=AwayGoals,fill=Percentage)) +
  geom_tile() +
  scale_fill_gradient2(low = "white", high = "red", limit=c(0,20))+ 
  labs(title = "Postseason Goals After Away Goal Rule Implemented")

#save data to reproduce wi D3
colnames(pmelt_post)<-c("homegoals","awaygoals","percentage")
pmelt_post["rule"]<-"TRUE"
colnames(pmelt_pre)<-c("homegoals","awaygoals","percentage")
pmelt_pre["rule"]<-"FALSE"
heat<-rbind(pmelt_post,pmelt_pre)
write.csv(heat,file = "heat.csv",row.names = F)
