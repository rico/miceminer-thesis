# 
# Author: rico
###############################################################################

##
# start procedure
library(igraph)
library(network)
library(sna)

#
# !!!!!!! only for testing
#
rm(list=ls(all=TRUE))
	

# load functions file
if(!exists("net_read")) {
	source("/Users/rico/Documents/workspace/miceminer_thesis/R/network_functions.R")
}

##
# Read in networks if not read yet

# 3h
#if(!exists("networks_1h")) {
	g_08_06_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_6.paj"	, "June `08")
	g_08_07_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_7.paj"	, "July `08")
	g_08_08_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_8.paj"	, "August `08")
	g_08_09_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_9.paj"	, "September `08")
	g_08_10_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_10.paj"	, "October `08")
	g_08_11_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_11.paj"	, "November `08")
	g_08_12_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_12.paj"	, "December `08")
	g_09_01_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_1.paj"	, "January `09")
	g_09_02_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_2.paj"	, "February `09")
	g_09_03_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_3.paj"	, "March `09")
	g_09_04_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_4.paj"	, "April `09")
	g_09_05_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_5.paj"	, "May `09")
	g_09_06_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_6.paj"	, "June `09")
	
	networks_3h <- list(g_08_06_3h,g_08_07_3h,g_08_08_3h,g_08_09_3h,g_08_10_3h,g_08_11_3h,g_08_12_3h,g_09_01_3h,g_09_02_3h,g_09_03_3h,g_09_04_3h,g_09_05_3h,g_09_06_3h)
#}

# 30h
if(!exists("networks_30h")) {
	g_08_06_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2008_6.paj"	, "June `08")
	g_08_07_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2008_7.paj"	, "July `08")
	g_08_08_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2008_8.paj"	, "August `08")
	g_08_09_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2008_9.paj"	, "September `08")
	g_08_10_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2008_10.paj"	, "Oktober `08")
	g_08_11_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2008_11.paj"	, "November `08")
	g_08_12_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2008_12.paj"	, "Dezember `08")
	g_09_01_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2009_1.paj"	, "January `09")
	g_09_02_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2009_2.paj"	, "February `09")
	g_09_03_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2009_3.paj"	, "March `09")
	g_09_04_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2009_4.paj"	, "April `09")
	g_09_05_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2009_5.paj"	, "May `09")
	g_09_06_30h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/30h/network_2009_6.paj"	, "June `09")
	
	networks_30h <- list(g_08_06_30h,g_08_07_30h,g_08_08_30h,g_08_09_30h,g_08_10_30h,g_08_11_30h,g_08_12_30h,g_09_01_30h,g_09_02_30h,g_09_03_30h,g_09_04_30h,g_09_05_30h,g_09_06_30h)
}
# all networks
#if(!exists("networks_all")) {
	networks_all <- append(networks_3h, networks_30h)
#}