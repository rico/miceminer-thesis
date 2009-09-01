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
#if(!exists("net_read")) {
	source("/Users/rico/Documents/workspace/miceminer_thesis/R/network_functions.R")
#}

##
# Read in networks if not read yet

# 1h
#if(!exists("networks_1h")) {
	g_08_06_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2008_6_1h.paj"	, "June `08")
	g_08_07_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2008_7_1h.paj"	, "July `08")
	g_08_08_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2008_8_1h.paj"	, "August `08")
	g_08_09_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2008_9_1h.paj"	, "September `08")
	g_08_10_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2008_10_1h.paj"	, "October `08")
	g_08_11_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2008_11_1h.paj"	, "November `08")
	g_08_12_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2008_12_1h.paj"	, "December `08")
	g_09_01_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2009_1_1h.paj"	, "January `09")
	g_09_02_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2009_2_1h.paj"	, "February `09")
	g_09_03_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2009_3_1h.paj"	, "March `09")
	g_09_04_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2009_4_1h.paj"	, "April `09")
	g_09_05_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2009_5_1h.paj"	, "May `09")
	g_09_06_1h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/1h/network_2009_6_1h.paj"	, "June `09")
	
	networks_1h <- list(g_08_06_1h,g_08_07_1h,g_08_08_1h,g_08_09_1h,g_08_10_1h,g_08_11_1h,g_08_12_1h,g_09_01_1h,g_09_02_1h,g_09_03_1h,g_09_04_1h,g_09_05_1h,g_09_06_1h)
#}

# 3h
#if(!exists("networks_3h")) {
#	g_08_06_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_6_3h.paj"	, "June `08")
#	g_08_07_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_7_3h.paj"	, "July `08")
#	g_08_08_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_8_3h.paj"	, "August `08")
#	g_08_09_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_9_3h.paj"	, "September `08")
#	g_08_10_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_10_3h.paj"	, "Oktober `08")
#	g_08_11_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_11_3h.paj"	, "November `08")
#	g_08_12_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2008_12_3h.paj"	, "Dezember `08")
#	g_09_01_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_1_3h.paj"	, "January `09")
#	g_09_02_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_2_3h.paj"	, "February `09")
#	g_09_03_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_3_3h.paj"	, "March `09")
#	g_09_04_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_4_3h.paj"	, "April `09")
#	g_09_05_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_5_3h.paj"	, "May `09")
#	g_09_06_3h <- net_read("/Users/rico/Documents/workspace/miceminer_thesis/graph_data/3h/network_2009_6_3h.paj"	, "June `09")
#	
#	networks_3h <- list(g_08_06_3h,g_08_07_3h,g_08_08_3h,g_08_09_3h,g_08_10_3h,g_08_11_3h,g_08_12_3h,g_09_01_3h,g_09_02_3h,g_09_03_3h,g_09_04_3h,g_09_05_3h,g_09_06_3h)
#}
# all networks
#if(!exists("networks_all")) {
#	networks_all <- append(networks_1h, networks_3h)
#}