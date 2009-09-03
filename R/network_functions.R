#
# Reads in a .paj file and make some conversions to it
# 
#
net_read <- function(file, label)
{
	graph <- read.paj(file)
	
	filename_parts = strsplit(file,"/")
	filename = filename_parts[[1]][ length(filename_parts[[1]]) ]
	network <- graph$networks[[1]]
	
	set.network.attribute(network,"LABEL", label)
	network <- net_convert(network)

	return (network)
	
}

#
# Returns the color for the nodes based on the gender
#
node_color <- function(gender_vec)
{
	
	gender_color = vector();
	
	for(i in 1:length(gender_vec)) {
		
		gender = gender_vec[i]
		
		if(gender == "u") {
			gender_color[i] = "gray35"
		} else if(gender == 'm') {
			gender_color[i] =  "deepskyblue"
		} else if(gender == 'f') {
			gender_color[i] = "deeppink"
		} 
		
	}
	return(gender_color)
}

#
# Turns network to undirected and adds a sex vertex attribute and a color attribute for node coloring
#
net_convert <- function(net)
{
	
	set.network.attribute(net, "directed", FALSE)
	set.vertex.attribute( net, "SEX", get.vertex.attribute(net, "8") )
	set.vertex.attribute( net, "NODE_COLOR",  node_color( get.vertex.attribute(net, "8") ) )
	delete.vertex.attribute( net, "8");
	delete.vertex.attribute( net, "7");
	delete.vertex.attribute( net, "bc");
	delete.vertex.attribute( net, "ic");

	return(net)
}

##
# General node level values
# (node count, females count, males count, unknown gender count, network density, edgecount, mean degree, average path length, clustering coefficient)
node_level_values <- function (net) {
	
	# the igraph package is used to draw some values wherefor no function is available in the statnet packages
	i_g = to_igraph(net);
	avgPathLength = round(average.path.length(i_g, directed=FALSE, unconnected=TRUE),4)
	clusteringC = round(transitivity(i_g, type="global"),4)
	

	values = c(vcount(i_g), count_attribute_occurance(net,"SEX","f") , count_attribute_occurance(net,"SEX","m"), count_attribute_occurance(net,"SEX","u"), vcount(i_g)*.5*(vcount(i_g) -1), ecount(i_g), round( gden(net,mode="graph"),4), round(mean(degree(i_g)),4), avgPathLength, clusteringC)
	
	return(values)
}

#
# The labels (rows) fo the node level indices
#
node_level_labels <- function() {
	value_labels = c("Nodes", "Females", "Males", "Unknown", "E max", "Edges", "Density", "Mean degree", "Average Path Length", "Clustering Coefficient")
	return(value_labels)
}

#
# count the value of a vertex attribute in a network
#
count_attribute_occurance <- function(net, attribute, value) {
	count = length( which( get.vertex.attribute(net, attribute) == value ) )
	return(count)
}

#
# node level indices as a data frame for the networks in the passed list
# The NODE_LEVEL_INDICES_LABELS and NODE_LEVEL_INDICES_VALUES must exist
#
node_level_values_as_data_frame <- function(nets, returnVec=FALSE) {
	
	# the data frame
	indices_frame = data.frame(value_labels=node_level_labels() )
	indices_vec = c()
	
	for( i in 1:length(nets) ) {
		indices_frame[[nets[[i]] %n% "LABEL"]] <- factor( node_level_values(nets[[i]]) )
		append(indices_vec, node_level_values(nets[[i]]),after=length(indices_vec))
	}
	
	if(returnVec) {
		return(indices_vec)
	} else {
		return(indices_frame)
	}
}

#
# create random (undirected) networks with a given number of vertices and edges (passed as a network object) 
# and calculate simple node level indices
#
random_test <- function(net, asList=FALSE, rand_nets = 2) {
	
	
	# data storage objects
	nodes_vec <- double()
	edges_vec <- double()
	mean_deg_vec <- double()
	avg_path_vec <- double()
	cc_vec <- c()
	indices_frame = data.frame(value_labels= c("Nodes","Edges","Mean Degree", "Average Path Length", "Clustering Coeff") )
	
	# original network
	i_net = to_igraph(net)
	indices_frame["orig"] <- factor( igraph_node_level_indices(i_net) )
	
	i = 0
	while(i < rand_nets) {
		# create random graphs
		g_rand = erdos.renyi.game(vcount(i_net),ecount(i_net),type="gnm", directed=FALSE)
		
		values = igraph_node_level_indices(g_rand);
		indices_frame[i+3] <- factor( values )
		nodes_vec <- append(nodes_vec,values[1])
		edges_vec <- append(edges_vec,values[2])
		mean_deg_vec<- append(mean_deg_vec,values[3])
		avg_path_vec <- append(avg_path_vec,values[4])
		cc_vec <- append(cc_vec,values[5])
		
		i = i+1
		#print(i)
	}
	
	if(asList == TRUE) {
		#print("list")
		indices_list = list(org=igraph_node_level_indices(i_net), nodes=nodes_vec, edges=edges_vec, mean_deg=mean_deg_vec,avg_path=avg_path_vec, cc=cc_vec)
		return(indices_list)
	} else {
		print("frame")
		return(indices_frame)
	}
	
}

#
# node level indices for an igraph graph
#
igraph_node_level_indices <- function(igraph) {

	indices = c( vcount(igraph), ecount(igraph), round(mean(degree.distribution(igraph)),4), round(average.path.length(igraph, directed=FALSE, unconnected=TRUE),4), round(transitivity(igraph, type="global"),4))
	
	return(indices)

}



#
# create igraph graph from network object edgelist
#
to_igraph <- function(net) {
	
	g = graph.adjacency(as.matrix(net,matrix.type="adjacency"), mode="undirected")
	return(g);
	
}

#
# Extract inner / inter gender networks
#
gender_extract <- function(net, asNets=FALSE) {


	net_label = net %n% "LABEL"
	
	# edgelist
	edgelst = edgelist <- as.edgelist(net)
	
	# edge list lengths out of mixing matrix
	mm_obj = mixingmatrix(net,"SEX")
	mm = mm_obj$matrix
	
	# initiating edge_lists
	data_mm = array(list(),c(mm[2,2],2))
	data_ff = array(list(),c(mm[1,1],2))
	data_fm = array(list(),c(mm[1,2],2))
	
	# edge lists counter
	mm_i = 1
	ff_i = 1
	fm_i = 1
	
	# Gender data vector
	sex = net %v% "SEX"
	
	# loop edge list
	row_num = 1
	while(row_num <= dim(edgelst)[1]) {
		edge = edgelst[row_num,]
		
		edge_from = edge[1]
		edge_to = edge[2]
		
		edge_from_sex = sex[edge_from]
		edge_to_sex = sex[edge_to]
		
		from_to = paste(edge_from_sex, edge_to_sex, sep = "")
		
		#print(from_to)
		
		# add to apropriate edge list
		if(from_to == "ff") {
	
			data_ff[ff_i,1] = edge[1]
			data_ff[ff_i,2] = edge[2]
			ff_i = ff_i + 1
			
		} else if(from_to == "mm") {
	
			data_mm[mm_i,1] = edge[1]
			data_mm[mm_i,2] = edge[2]
			mm_i = mm_i +1
			
		} else if(from_to == "fm" || from_to == "mf") {
	
			data_fm[fm_i,1] = edge[1]
			data_fm[fm_i,2] = edge[2]
			fm_i = fm_i + 1
		}
		
		row_num = row_num + 1;
		
	}
	
	data_ff[, c(1,2)] <- data_ff[ , c(2,1)]
	data_mm[, c(1,2)] <- data_mm[ , c(2,1)]
	data_fm[, c(1,2)] <- data_fm[ , c(2,1)]
	
	# convert matrix like list to matrix
	edgelist_ff <- matrix(unlist(data_ff), ncol=2)
	edgelist_mm <- matrix(unlist(data_mm), ncol=2)
	edgelist_fm <- matrix(unlist(data_fm), ncol=2)
	
	# creating networks
	net_ff = network(edgelist_ff,matrix.type="edgelist",directed=FALSE)
	label_ff = paste(net_label,"(ff)", sep=" ")
	set.network.attribute(net_ff, "LABEL", "ff")
	
	net_mm = network(edgelist_mm,matrix.type="edgelist",directed=FALSE)
	label_mm = paste(net_label,"(mm)", sep=" ")
	set.network.attribute(net_mm, "LABEL", "mm")	
	
	net_fm = network(edgelist_fm,matrix.type="edgelist",directed=FALSE)
	label_fm = paste(net_label,"(fm)", sep=" ")
	set.network.attribute(net_fm, "LABEL", "fm")	
	
	networks = list(net_ff,net_mm, net_fm)
	#networks = c(net_ff,net_mm, net_fm)
	
	if(asNets == TRUE) {
		nets = list("ff"=net_ff,"mm"=net_mm, "mf"=net_fm)
	} else {
		indices_frame = data.frame(value_labels= c("Nodes","Edges","Mean degree", "Average Path Length", "Cc","Mean betweenness") )	
		indices_frame[label_ff] <- factor( gender_extract_node_level_values(net_ff,length(unique(unlist(data_ff)))) )
		indices_frame[label_mm] <- factor( gender_extract_node_level_values(net_mm,length(unique(unlist(data_mm)))) )
		indices_frame[label_fm] <- factor( gender_extract_node_level_values(net_fm,length(unique(unlist(data_fm)))) )
			
		return(indices_frame)
	}
	


}

#
# node level indices for gender extracted networ
# 
gender_extract_node_level_values <- function(net, nodes) {
	
	igraph = to_igraph(net);
	
	indices = c( nodes, ecount(igraph), round(mean(degree.distribution(igraph)),3), round(average.path.length(igraph, directed=FALSE, unconnected=TRUE),3), round(transitivity(igraph, type="global"),3), round(mean(betweenness(igraph, directed = FALSE)),3) )
	
	return(indices)
	
}


#
# get gender based on indices
#
get_gender <- function(net, index) {

	sex = net %v% "SEX" 
	
	index_sex = sex[index]

	return(index_sex)
}


#
# plot network
#