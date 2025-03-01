#Rarefied table. We had an issue with this before. 
otu_table <- read.table("table_from_HMP.txt", 
                        comment="",
                        header=TRUE,
                        sep="\t",
                        skip=1,
                        as.is=TRUE,
                        check.names=F,
                        row=1)

metadata <- read.table("HMP_mapping_file.txt", 
                       sep = "\t", 
                       comment="", 
                       header=T,
                       check.names=F, 
                       row=1)


#Converted from qza -> biom -> tsv
alpha <- as.data.frame(read.table("alpha-diversity.txt",
                                  sep='\t',
                                  header=TRUE,
                                  as.is=TRUE,
                                  check.names=FALSE,
                                  row=1))

# making a copy of our metadata to work with
metadata_sub <- metadata[metadata$CHRONIC_CONDITION=="n" | metadata$CHRONIC_CONDITION=="y",] 
metadata_sub <- metadata[metadata$BODY_SITE=="UBERON:feces",]

IDs_Keep <- intersect(colnames(otu_table), rownames(metadata_sub))

# Now let's filter the metadata to keep only those samples
metadata2 <- metadata[IDs_Keep,]



# Alpha diversity has the samples as row names
alpha <- alpha[IDs_Keep, ]

#Add an alpha column to the metadata
#metadata.alpha <- as.data.frame(metadata2$alpha)



## PLOTTING

# loading needed package
library(ggplot2)

x_labels <- c('Gut')

# plotting the data
# geom_boxplot plots the shannon data in boxplots, separating the values by body site
# scale_fill_manuel fills the boxplots with colors representing chronic condition status
# labs adds labels and a caption (our names)
ggplot() +
  geom_boxplot(data=metadata2, aes(x= BODY_SITE, y= alpha, fill= CHRONIC_CONDITION)) +
  scale_fill_manual(values= c("cadetblue3", "white"), labels = c("No Chronic Condition", "Chronic Condition"), name = "") + labs(x = "Chronic Condition Status", y = "Shannon's Diversity Index") +
  scale_x_discrete(labels = x_labels) + theme(legend.position="bottom")

