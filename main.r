library(moments) 

blueberriesData <- scan("blueberriesData.txt", double(), quote = "")
redberriesData <- scan("redberriesData.txt", double(), quote = "")

EMeasuresOfAssociation <- list(Mean = 1, Mode = 2, Minimum = 3, FirstQuartile = 4, Median = 5, ThirdQuartile = 6, Maximum = 7)

MeasuresOfAssociation <- function(data)
{
  Mode <- function(data)  
  {
    uniqueVector <- unique(data)
    countTab <- tabulate(match(data, uniqueVector))
    resultIndex <- which.max(countTab)
    resultCount <- countTab[resultIndex]
    
    checkTab <- tabulate(countTab);
    
    if(checkTab[resultCount] > 1)
      return (NA)
    
    return (uniqueVector[resultIndex])
  }
  
  result <- vector(mode = "list", length = 7)
  
  names(result)[EMeasuresOfAssociation$Mean] = "Mean"
  result[EMeasuresOfAssociation$Mean] <- mean(data)
  
  names(result)[EMeasuresOfAssociation$Mode] = "Mode"
  result[EMeasuresOfAssociation$Mode] <- Mode(data)
  
  names(result)[EMeasuresOfAssociation$Minimum] ="Null quartile - minumum"
  result[EMeasuresOfAssociation$Minimum] <- quantile(data, 0.00)
  
  names(result)[EMeasuresOfAssociation$FirstQuartile] ="First quartile"
  result[EMeasuresOfAssociation$FirstQuartile] <- quantile(data, 0.25)
  
  names(result)[EMeasuresOfAssociation$Median] ="Second quartile - median"
  result[EMeasuresOfAssociation$Median] <- quantile(data, 0.50)
  
  names(result)[EMeasuresOfAssociation$ThirdQuartile] ="Third quartile"
  result[EMeasuresOfAssociation$ThirdQuartile] <- quantile(data, 0.75)
  
  names(result)[EMeasuresOfAssociation$Maximum] ="Fourth quartile - maximum"
  result[EMeasuresOfAssociation$Maximum] <- quantile(data, 1.00)
  
  return (result)
}

EMeasuresOfDiversity <- list(ResultsRange = 1, InterquartileRange = 2, Variance = 3, StandardDeviation = 4, VariationCoefficient = 5)

MeasuresOfDiversity <- function(data, associationMeasuresData)
{
  result <- vector(mode = "list", length = 5)
  
  names(result)[EMeasuresOfDiversity$ResultsRange] = "ResultsRange"
  result[EMeasuresOfDiversity$ResultsRange] <- (associationMeasuresData[[EMeasuresOfAssociation$Maximum]] - associationMeasuresData[[EMeasuresOfAssociation$Minimum]]) 
  
  names(result)[EMeasuresOfDiversity$InterquartileRange] = "InterquartileRange"
  result[EMeasuresOfDiversity$InterquartileRange] <- IQR(data)
  
  dataLength <- length(data)
  variance <- var(data) * (dataLength - 1) / dataLength;  
  
  names(result)[EMeasuresOfDiversity$Variance] = "Variance"
  result[EMeasuresOfDiversity$Variance] <- variance
  
  standardDeviation <- sqrt(variance)
  
  names(result)[EMeasuresOfDiversity$StandardDeviation] = "StandardDeviation"
  result[EMeasuresOfDiversity$StandardDeviation] <- standardDeviation
  
  names(result)[EMeasuresOfDiversity$VariationCoefficient] = "VariationCoefficient"
  result[EMeasuresOfDiversity$VariationCoefficient] <- (standardDeviation / associationMeasuresData[[EMeasuresOfAssociation$Mean]])
  
  return (result)
}

EMeasuresOfAsymmetry <- list(SkewnessCoefficient = 1)

MeasuresOfAsymmetry <-function(data)
{
  result <- vector(mode = "list", length = 1)
  
  names(result)[EMeasuresOfAsymmetry$SkewnessCoefficient] = "SkewnessCoefficient"
  result[EMeasuresOfAsymmetry$SkewnessCoefficient] <- skewness(data)
  
  return (result)
}

EMeasuresOfConcentration <- list(Kurtosis = 1)

MeasuresOfConcentration <-function(data)
{
  result <- vector(mode = "list", length = 1)
  
  names(result)[EMeasuresOfConcentration$Kurtosis] = "Kurtosis"
  result[EMeasuresOfConcentration$Kurtosis] <- kurtosis(data)
  
  return (result)
}

CalculateHistogramBreaks <- function(data, associationMeasuresData)
{
  minimum <- associationMeasuresData[[EMeasuresOfAssociation$Minimum]]
  maximum <- associationMeasuresData[[EMeasuresOfAssociation$Maximum]]
  rangeLength <- (maximum - minimum) / sqrt(length(data))
  
  result <- seq(minimum, maximum, rangeLength)
  
  return (result);
}

blueberriesMeasuresOfAssociations <- MeasuresOfAssociation(blueberriesData)
blueberriesMeasuresOfAssociations
MeasuresOfDiversity(blueberriesData, blueberriesMeasuresOfAssociations)
MeasuresOfAsymmetry(blueberriesData)
MeasuresOfConcentration(blueberriesData)
blueberriesHistogramBreaks <- CalculateHistogramBreaks(blueberriesData, blueberriesMeasuresOfAssociations)

#hist(blueberriesData, breaks = blueberriesHistogramBreaks)

redberriesMeasuresOfAssociations <- MeasuresOfAssociation(redberriesData)
redberriesMeasuresOfAssociations
MeasuresOfDiversity(redberriesData, redberriesMeasuresOfAssociations)
MeasuresOfAsymmetry(redberriesData)
MeasuresOfConcentration(redberriesData)
redberriesHistogramBreaks <- CalculateHistogramBreaks(redberriesData, redberriesMeasuresOfAssociations)

#hist(redberriesData, breaks = redberriesHistogramBreaks)


#zadanie 2 



Ko�mogorow <- function(database)
{
data<- sort(database)
n <-length(data)
standardScore<-data 
empiricalDistribution<-data 
hypotheticalDistribution <- data
difference <-data
mean<-mean(data)
standardDeviation<- sd(data)
distributionTable = 0.264 

for (i in 1:n) 
{
  standardScore[i] <- (data[i]- mean)/standardDeviation
}

for (i in 1:n) 
{
  hypotheticalDistribution[i] <- pnorm(standardScore[i])
}

for (i in 1:n) 
{
  empiricalDistribution[i]<-i/ length(data)
}


for (i in 1:n) 
{
  difference[i] <-abs(hypotheticalDistribution[i] - empiricalDistribution[i])
}


testStatisticValue<-max (difference)

#writeLines("H0 - normal distribution\n")
#writeLines("H1 - non normal distribution\n")


if(testStatisticValue < distributionTable || testStatisticValue> 1){
  writeLines("We can't rule out hypothesis H0\n")
  writeLines("Normal distribution\n")
}else{
  writeLines("We can rule out hypothesis H0\n")
  writeLines("Non normal distribuion\n")
}
}
writeLines("blueberries:\n")
blueberrieKo�mogorow <- Ko�mogorow(blueberriesData)
blueberrieKo�mogorow
writeLines("redberries:\n")
redberrieKo�mogorow <- Ko�mogorow(redberriesData)
redberrieKo�mogorow


#zad 3
AlfaFact <- 0.02

NormFact <- function(ufn)
{
  return (qnorm(ufn))
}

FactNorm <- NormFact(1 - AlfaFact/2)
FactNorm

redberriesDownlimitMean <- redberriesMeasuresOfAssociations$Mean - (FactNorm*redberriesMeasuresOfDiversity$Variance/sqrt(length(redberriesData)))
redberriesDownlimitMean
redberriesUplimitMean <- redberriesMeasuresOfAssociations$Mean + (FactNorm*redberriesMeasuresOfDiversity$Variance/sqrt(length(redberriesData)))
redberriesUplimitMean

redberriesPrecisionMean <- ((FactNorm*redberriesMeasuresOfDiversity$Variance/sqrt(length(redberriesData)))/redberriesMeasuresOfAssociations$Mean) * 100
redberriesPrecisionMean

#zad 4


blueberriesDownlimitMean <- sqrt(blueberriesMeasuresOfAssociations$Mean) - FactNorm*sqrt(blueberriesMeasuresOfAssociations$Mean)/sqrt(2*length(blueberriesData))
blueberriesDownlimitMean
blueberriesUplilitMean <- sqrt(blueberriesMeasuresOfAssociations$Mean) + FactNorm*sqrt(blueberriesMeasuresOfAssociations$Mean)/sqrt(2*length(blueberriesData))
blueberriesUplilitMean

#zad 5
blueberriesMeasuresOfAssociations <- MeasuresOfAssociation(blueberriesData)
blueberriesMeasuresOfAssociations$Mean
blueberriesMeasuresOfDiversity <- MeasuresOfDiversity(blueberriesData, blueberriesMeasuresOfAssociations)
blueberriesMeasuresOfDiversity$Variance
redberriesMeasuresOfAssociations <- MeasuresOfAssociation(redberriesData)
redberriesMeasuresOfAssociations$Mean
redberriesMeasuresOfDiversity <- MeasuresOfDiversity(redberriesData, redberriesMeasuresOfAssociations)
redberriesMeasuresOfDiversity$Variance

Statistic <- (redberriesMeasuresOfAssociations$Mean-blueberriesMeasuresOfAssociations$Mean)/sqrt(blueberriesMeasuresOfDiversity$Variance/25+redberriesMeasuresOfDiversity$Variance/25)
Statistic

