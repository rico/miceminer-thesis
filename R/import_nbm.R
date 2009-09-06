#
# Import node based measures to tables
#


#
# as tables
#

nbmt <- list()

nbmt[["06_08"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_6_2008.txt", header = TRUE)
nbmt[["07_08"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_7_2008.txt", header = TRUE)
nbmt[["08_08"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_8_2008.txt", header = TRUE)
nbmt[["09_08"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_9_2008.txt", header = TRUE)
nbmt[["10_08"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_10_2008.txt", header = TRUE)
nbmt[["11_08"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_11_2008.txt", header = TRUE)
nbmt[["12_08"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_12_2008.txt", header = TRUE)
nbmt[["01_09"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_1_2009.txt", header = TRUE)
nbmt[["02_09"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_2_2009.txt", header = TRUE)
nbmt[["03_09"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_3_2009.txt", header = TRUE)
nbmt[["04_09"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_4_2009.txt", header = TRUE)
nbmt[["05_09"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_5_2009.txt", header = TRUE)
nbmt[["06_09"]] <- read.table("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/node_based_measures_30h/csv/node_based_measures_6_2009.txt", header = TRUE)

#
# as matrices
#

nbmm <- list()

nbmm[["06_08"]] <- as.matrix(nbmt[["06_08"]])
nbmm[["07_08"]] <- as.matrix(nbmt[["07_08"]])
nbmm[["08_08"]] <- as.matrix(nbmt[["08_08"]])
nbmm[["09_08"]] <- as.matrix(nbmt[["09_08"]])
nbmm[["10_08"]] <- as.matrix(nbmt[["10_08"]])
nbmm[["11_08"]] <- as.matrix(nbmt[["11_08"]])
nbmm[["12_08"]] <- as.matrix(nbmt[["12_08"]])
nbmm[["01_09"]] <- as.matrix(nbmt[["01_09"]])
nbmm[["02_09"]] <- as.matrix(nbmt[["02_09"]])
nbmm[["03_09"]] <- as.matrix(nbmt[["03_09"]])
nbmm[["04_09"]] <- as.matrix(nbmt[["04_09"]])
nbmm[["05_09"]] <- as.matrix(nbmt[["05_09"]])
nbmm[["06_09"]] <- as.matrix(nbmt[["06_09"]])

#
# calculate averages
#

#
# lapply functions
#

mean_path <- function(elem) {
	val = mean(as.numeric(elem[,4]))
	return(val)
}

mean_clust <- function(elem) {
	val = mean(as.numeric(elem[,5]))
	return(val)	
}

mean_degree <- function(elem) {
	val = mean(as.numeric(elem[,6]))
	return(val)
}

mean_bet <- function(elem) {
	val = mean(as.numeric(elem[,7]))
	return(val)
}


# averages as data frame 

#avg_frame = data.frame(value_labels= c("avg. path length", "mean clust","mean degree", "avg. betweenness" ) )
#mean_path_values <- lapply(nbmm, mean_path)
#mean_clust_values <- lapply(nbmm, mean_clust)
#mean_deg_values <- lapply(nbmm, mean_degree)
#mean_bet_values <- lapply(nbmm, mean_bet)





