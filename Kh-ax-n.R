

setwd("~/Google Drive")

library(RCurl)
library(metricsgraphics)
library(XML)

google.counts<-function(s){
  search.url<-paste("http://www.google.com/search?q=",gsub(" ","+",s),sep="")
  search.html<-getURL(search.url)
  parse.search<-htmlTreeParse(search.html,useInternalNodes = TRUE)
  nodes<-getNodeSet(parse.search,"//div[@id='resultStats']")
  value<-strsplit(xmlValue(nodes[[1]])," ",fixed=TRUE)[[1]][2]
  return(as.numeric(gsub(",","",value,fixed=TRUE)))
}

##Start value
  keyword <- "KHN"
  max <- 1000
  results<-as.matrix(data.frame(0,0)) #log for the results

#Loop through
  for( i in 1:max){
    keyword <-paste(substr(keyword,1,nchar(keyword)-1),"A","N",sep="")
    results<-rbind(results,as.matrix(data.frame(i,google.counts(keyword))))
    print(keyword)
  }
  
  results2<-results[2:nrow(results),]
  write.csv(results2,"khan.csv",row.names=F)


#Interactive graph
  df <- as.data.frame(results2)
  colnames(df)<-c("i","results")
  df$results<-log(df$results)
  mjs_plot(df, x=i, y=results) %>%
    mjs_labs(x="Number of A's in KH(Ax)N", y="log(Google Results)")

