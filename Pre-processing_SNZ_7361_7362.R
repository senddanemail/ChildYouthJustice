#======================================================================
# Table 7361: Children and Youth charges: repeat each line by the number in the Value field

setwd("/home/ubuntu/ChildYouthJustice/Datasets/")
csvdf    <- read.csv("TABLECODE7361_ALL_Data_Children and young people charged in court - most serious offence calendar year.csv", stringsAsFactors = FALSE)
names(csvdf)[names(csvdf) == "Main.offence"] <- "MainOffence"  # Remove dot from column name

outputdf <- csvdf[order(csvdf$Year, csvdf$Gender, csvdf$Ethnicity, csvdf$Age, csvdf$Outcome, csvdf$MainOffence),]

# Remove all group summary rows (i.e., totals)
rep_unique_outputdf <- subset(outputdf, Age != "Total Age" & MainOffence != "Total Offences" & Gender != "Total Gender" & Ethnicity != "Total Ethnicity" & Outcome != "Total Outcomes")
totrows <- length(rep_unique_outputdf$Value)
totrows

# Extract only those outcomes that will not be included in Table 7362 (e.g., discharged, dismissed, withdrawn, etc.)
rep_unique_outputdf <- subset(rep_unique_outputdf, (Outcome == "Youth Court proved (absolute discharge under s282)" | Outcome == "Dismissed" | Outcome == "Withdrawn"))

totrows <- length(rep_unique_outputdf$Value)
totrows

# For the moment, set 3 to 1 (to counteract SNZ's automatic rounding of 1 and 2 to 3)
rep_unique_outputdf$Value[rep_unique_outputdf$Value == 3] <- 1

# Duplicate rows by the Value count
dup_unique_outputdf_7361 <- rep_unique_outputdf[rep(row.names(rep_unique_outputdf), rep_unique_outputdf$Value),]

#======================================================================
# Table 7362: Child and Youth Sentences: repeat each line by the number in the Value field

csvdf    <- read.csv("TABLECODE7362_ALL_Data_Children and young people given an order in court - most serious offence calendar year.csv", stringsAsFactors = FALSE)
names(csvdf)[names(csvdf) == "Main.offence"] <- "MainOffence" # Remove dot from column name

ordersdf <- csvdf[order(csvdf$Year, csvdf$Gender, csvdf$Ethnicity, csvdf$Age, csvdf$Order, csvdf$MainOffence),]
head(ordersdf)
ordersdf$Year <- as.factor(ordersdf$Year)

# filter out rows that provide Total counts for categories
rep_unique_outputdf <- subset(ordersdf, Age != "Total Age" & MainOffence != "Total Offences" & Gender != "Total Gender" & Ethnicity != "Total Ethnicity" & Order != "Total Sentences")
totrows <- length(rep_unique_outputdf$Value)
totrows

# For the moment, set 3 to 1 (to counteract SNZ's automatic rounding of 1 and 2 to 3)
rep_unique_outputdf$Value[rep_unique_outputdf$Value == 3] <- 1

# Duplicate rows by the Value count
dup_unique_outputdf_7362 <- rep_unique_outputdf[rep(row.names(rep_unique_outputdf), rep_unique_outputdf$Value),]

# Merge the data frames
colnames(dup_unique_outputdf_7362)[6] <- "Outcome"
dup_unique_outputdf <- rbind(dup_unique_outputdf_7361, dup_unique_outputdf_7362)

# Replace commas with semi-colons
dup_unique_outputdf$Outcome <- gsub(',',';',dup_unique_outputdf$Outcome)

# Write output file
write.csv(dup_unique_outputdf, "child_youth_stats_repeated.csv")

#======================================================================
