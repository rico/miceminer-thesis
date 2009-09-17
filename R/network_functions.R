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
			gender_color[i] = "grey77"
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
	
	# whole net
	i_g = to_igraph(net);
	# components
	comps = igraph::clusters(i_g)
	
	n = vcount(i_g)
	f = count_attribute_occurance(net,"SEX","f")
	m = count_attribute_occurance(net,"SEX","m")
	u = count_attribute_occurance(net,"SEX","u")
	comp = length(unique(comps$membership)) - length(isolates(net))
	emax = vcount(i_g)*.5*(vcount(i_g) -1)
	e = ecount(i_g)
	den = round( gden(net,mode="graph"),2)
	deg	= round(mean(igraph::degree(i_g)),2)
	apl = round(average.path.length(i_g, directed=FALSE, unconnected=TRUE),2)
	cc = round(transitivity(i_g, type="global"),2)
	bet = round(mean(betweenness(net, gmode="graph")),2)
	deg_corr = round(degree_corr(net),2)
	ass_coeff = round(assort_coeff(net),2)
	
	# gender networks	
	g_nets = gender_extract(net, asNets=T)
	
	
	# cc
	cc_loc = transitivity(i_g, type="local")

	cc_m_all <- cc_loc[which(net %v% "SEX" =="m")]

	# females net
	net_f = g_nets$ff
	net_f_i = to_igraph(net_f)
	comp_f = length(unique(comps$membership[which(net %v% "SEX" == "f")])) - length(which(c(net %v% "SEX")[isolates(net)] == "f")) 
	e_f = ecount(net_f_i)
	deg_f = round(mean(degree(net, nodes=c( which(net %v% "SEX" == "f")), gmode="graph")),2)
	cc_f = round(mean(cc_loc[which(net %v% "SEX" =="f")], na.rm=T),2)
	bet_f = round(mean(betweenness(net, nodes=c(which(net %v% "SEX" == "f")), gmode="graph")),2)
	
	# males net
	net_m = g_nets$mm
	net_m_i = to_igraph(net_m)
	comp_m = length(unique(comps$membership[which(net %v% "SEX" == "m")])) - length(which(c(net %v% "SEX")[isolates(net)] == "m"))
	e_m = ecount(net_m_i)
	deg_m = round(mean(degree(net, nodes=c( which(net %v% "SEX" == "m")), gmode="graph")),2)
	cc_m = round(mean(cc_loc[which(net %v% "SEX" =="m")], na.rm=T),2)
	bet_m = round(mean(betweenness(net, nodes=c(which(net %v% "SEX" == "m")), gmode="graph")),2)
	
	# males-females net
	net_fm = g_nets$fm
	net_fm_i = to_igraph(net_fm)
	e_fm = ecount(net_fm_i)
	
	values = c(n, f, m, u, comp, comp_f, comp_m, emax, e, e_f, e_m, e_fm, den, deg, deg_f, deg_m, apl, cc, cc_f, cc_m, bet, bet_f, bet_m, deg_corr, ass_coeff)
	
	#values = list("n" = n, "f" = f, "m" = m, "u" = u, "comp" = comp,"comp_f" = comp_f, "comp_m" = comp_m, "emax" = emax, "e" = e, "ef" = e_f, "em" = e_m, "e_fm" = e_fm, "den" = den, "deg" = deg, "deg_f" = deg_f, "deg_m" = deg_m, "apl" = apl, "apl_f"=apl_f, "apl_m"=apl_m, "cc"=cc, "cc_f"=cc_f, "cc_m"=cc_m, "deg_corr"=deg_corr, "ass_coeff"=ass_coeff)
	
	return(values)
}

#
# The labels (rows) fo the node level indices
#
node_level_labels <- function() {

	value_labels = c("Nodes", "Females", "Males", "Unknown", "Components", "Components (f)", "Components (m)", "E max", "Edges", "Edges (ff)", "Edges (mm)", "Edges (fm)", "Density", "Mean degree", "Mean Deg (f)", "Mean deg (m)",  "Average Path Length", "Clustering Coefficient", "CC (f)", "CC (m)", "Betweenness", "Betweenness (f)", "Betweenness (m)", "Degree Corr.", "Assort. Coeff")
	
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
node_level_values_as_data_frame <- function(nets, returnVec=FALSE, returnM=FALSE, named=F) {
	
	# the data frame
	indices_frame = data.frame(value_labels=node_level_labels() )
	
	indices_vec = c()
	
	for( i in 1:length(nets) ) {
	
		indices_frame[[nets[[i]] %n% "LABEL"]] <- factor( node_level_values(nets[[i]]) )
		indices_vec = append(indices_vec, node_level_values(nets[[i]]),after=length(indices_vec))
		
	}
	
	if(returnVec) {
		return(indices_vec)
	} else if (returnM) {
		indices_m = matrix( indices_vec, nrow=length(node_level_labels()), ncol=length(nets) )
		
		if(named == T) {
			dimnames(indices_m) = list(as.list(node_level_labels()), as.list(names(indices_frame)[which(names(indices_frame) !="value_labels")]))
		}
		
		return(indices_m)
	} else {
	
		return(indices_frame)
	}
}

#
# create random (undirected) networks with a given number of vertices and edges (passed as a network object) 
# and calculate simple node level indices
#
random_test <- function(net, asList=FALSE, rand_nets = 100) {
	
	
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
# run gender extract over a stack of networks
#
gender_extract_nets <- function(nets) {

	# the data frame
	indices_frame_ff = data.frame(value_labels= c("Nodes (connected)", "Edges","Mean degree", "Average Path Length", "Cc","Mean betweenness") )
	indices_frame_mm = data.frame(value_labels= c("Nodes (connected)", "Edges","Mean degree", "Average Path Length", "Cc","Mean betweenness") )
	indices_frame_fm = data.frame(value_labels= c("Nodes (connected)", "Edges","Mean degree", "Average Path Length", "Cc","Mean betweenness") )
	
	for( i in 1:length(nets) ) {
		indices = gender_extract(nets[[i]], valuesOnly=TRUE)
		indices_frame_ff[[nets[[i]] %n% "LABEL"]] <- indices$ff
		indices_frame_mm[[nets[[i]] %n% "LABEL"]] <- indices$mm
		indices_frame_fm[[nets[[i]] %n% "LABEL"]] <- indices$fm
		
	}
	
	indices = list("ff"= indices_frame_ff, "mm"= indices_frame_mm, "fm"=indices_frame_fm)
	
	return(indices)
	

}

#
# Extract inner / inter gender networks
#
gender_extract <- function(net, asNets=FALSE, valuesOnly=FALSE) {

	# label
	net_label = net %n% "LABEL"
	# gender
	sex = net %v% "SEX"
	# node colors
	node_colors = net %v% "NODE_COLOR"
	# vertex names
	vnames = net %v% "vertex.names"
	
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
	
	if( length(data_ff) == 0) {
		print("ff")
		net_ff = network.initialize(1)

	} else {
		data_ff[, c(1,2)] <- data_ff[ , c(2,1)]
		edgelist_ff <- matrix(unlist(data_ff), ncol=2)
		
		net_ff = network(edgelist_ff,matrix.type="edgelist",directed=FALSE)
		label_ff = paste(net_label,"(ff)", sep=" ")
		set.network.attribute(net_ff, "LABEL", "ff")
		set.vertex.attribute(net_ff, "NODE_COLOR", node_colors)
		set.vertex.attribute(net_ff, "vertex.names", vnames)
		set.vertex.attribute(net_ff, "SEX", sex)
	}
	
	if( length(data_mm) == 0) {
		
		print( paste("mm", net_label, sep= " "))
		net_mm = network.initialize(1)

	} else {
		data_mm[, c(1,2)] <- data_mm[ , c(2,1)]
		edgelist_mm <- matrix(unlist(data_mm), ncol=2)
		
		net_mm = network(edgelist_mm,matrix.type="edgelist",directed=FALSE)
		label_mm = paste(net_label,"(mm)", sep=" ")
		set.network.attribute(net_mm, "LABEL", "mm")
		set.vertex.attribute(net_mm, "NODE_COLOR", node_colors)	
		set.vertex.attribute(net_mm, "vertex.names", vnames)
		set.vertex.attribute(net_mm, "SEX", sex)
	}
	
	if( length(data_fm) == 0) {
		print("fm")
		net_fm = network.initialize(1)

	} else {
		data_fm[, c(1,2)] <- data_fm[ , c(2,1)]
		edgelist_fm <- matrix(unlist(data_fm), ncol=2)
		
		net_fm = network(edgelist_fm,matrix.type="edgelist",directed=FALSE)
		label_fm = paste(net_label,"(fm)", sep=" ")
		set.network.attribute(net_fm, "LABEL", "fm")
		set.vertex.attribute(net_fm, "NODE_COLOR", node_colors)
		set.vertex.attribute(net_fm, "vertex.names", node_colors)
		set.vertex.attribute(net_fm, "vertex.names", vnames)	
		set.vertex.attribute(net_fm, "SEX", sex)		
	}

	
	if(asNets == TRUE) {
	
		nets = list("ff"=net_ff,"mm"=net_mm, "fm"=net_fm)
		return(nets)
		
	} else {
		
		indices_ff = gender_extract_node_level_values(net_ff,length(unique(unlist(data_ff))))
		indices_mm = gender_extract_node_level_values(net_mm,length(unique(unlist(data_mm))))
		indices_fm = gender_extract_node_level_values(net_fm,length(unique(unlist(data_fm))))
		
		if(valuesOnly == FALSE) {
			indices_frame = data.frame(value_labels= c("Nodes (connected)", "Edges","Mean degree", "Average Path Length", "Cc","Mean betweenness") )	
			indices_frame[label_ff] <- factor( indices_ff )
			indices_frame[label_mm] <- factor( indices_mm )
			indices_frame[label_fm] <- factor( indices_fm )
			
			return(indices_frame)
			
		} else {
			indices_values = list(
				"ff" = indices_ff,
				"mm" = indices_mm,
				"fm" = indices_fm
			)
			
			return(indices_values)
		}
			

	}
	


}

#
# node level indices for gender extracted networ
# 
gender_extract_node_level_values <- function(net, nodes) {
	
	igraph = to_igraph(net);
	
	indices = c(nodes, igraph::ecount(igraph), round(mean(igraph::degree.distribution(igraph)),3), round(igraph::average.path.length(igraph, directed=FALSE, unconnected=TRUE),3), round(igraph::transitivity(igraph, type="global"),3), round(mean(igraph::betweenness(igraph, directed=FALSE)),3) )
	
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
custom_plot <- function(net, dl=FALSE, di=FALSE, colored=TRUE, hl=c(), hlc=TRUE, hlf=1.3, genders=c(), prop=c(), tit="") {

	vert = length(net %v% "vertices")
	
	# node sizes
	v_sizes = 1
	
	# node border color
	v_borders = "black"
	
	# colored nodes
	if(colored == T) {
		v_colors = net %v% "NODE_COLOR"	
		
		if( length(genders) > 0) {
			
			v_borders = rep("black", times=vert)
			
			i = 1
			for( i in 1:vert ) {
				gender = get_gender(net, i)
				if(length((which(genders == gender))) == 0 ) {
				
					v_borders[i] = "white"
					v_colors[i] = "white"
				} 				

			}
			
		}
		
	} else {
		v_colors = rep("grey77", times=vert)
	}
	
	# highlight nodes
	if(length(hl) != 0) {
	
		v_sizes= rep(1, times=vert)
		
		i= 1
		for( i in 1:length(hl) ) {
			if(hlc == TRUE) {
				v_colors[ hl[i] ] = "red2"
			}
			v_sizes[ hl[i] ] = hlf
			
			i = i + 1
		}
	
	}
	
	# proportional node sizes
	if( length(prop) != 0) {
		v_sizes = prop
	}
	
	
	
	
	
	plot(net, layout.par=list(repulse.rad=40000), vertex.col=v_colors, vertex.cex=v_sizes, vertex.border=v_borders, vertex.sides=30, object.scale=0.015, displayisolates=di, displaylabels=dl, boxed.labels=F, label.cex=0.5, label.pos=3, main=tit)
}

#
# degree layout
#
network.layout.deg_bet <- function(d, layout.par){ 
	deg <- degree(d, cmode = "indegree") 
	bet <- betweenness(d, gmode="graph", cmode="undirected")
	cbind(deg, bet) 
}


#
# normalize to the values specified by max
#
normalize <- function (values, lower=0.5, upper=2) {
	
	# min / max values in vector
	min_value = min(values)
	max_value = max(values)

	normalized_values = c()
	
	i = 1
	for( i in 1:length(values) ) {
	
		norm_value = lower + (values[i] - min_value)*(upper - lower)/(max_value - min_value)
		
		#y = 1 + (x-A)*(10-1)/(B-A)
		
		#y = lower + (values[i] - min_value)*(upper - lower)/(max_value - min_value)
		
		#A: min_value
		#B: max_value
		#1: lower
		#10: upper
		#x: values[i]
		
		
		normalized_values = append(normalized_values, norm_value)
		i = i + 1
	}
	

	return(normalized_values)
	
}

#
# calculate assortativity index for the SEX attribute based on Newman (2003)
#
assort_coeff <- function(net) {

	# mixing_atrix
	mm_obj = mixingmatrix(net, "SEX")
	mm = mm_obj$matrix
	
	# sum of edges (known gender)
	e_sum = mm[2,2] + mm[1,1] + mm[1,2]
	
	# edge proportions Eii, Eij
	e_mm = mm[2,2] / e_sum
	e_ff = mm[1,1] / e_sum
	e_fm = (mm[1,2] / 2) / e_sum
	e_mf = (mm[1,2] / 2) / e_sum
	
	
	r = ( e_mm + e_ff - (e_mm+e_mf)^2 - (e_ff + e_fm)^2 ) / ( 1 - (e_mm + e_mf)^2 - (e_ff + e_fm)^2 )
	
	r = round(r,4)
	
	return(r)

}


#
# calculate standard deviation for assort coeff
# 
assort_coeff_dev <- function(net, rvals=F) {
	
	net_clean = network.copy(net)
	net_clean = del_u_edges(net_clean)
	
	n_edges = length(as.matrix(net_clean,matrix.type="edgelist")) / 2

	edgelist = as.matrix(net_clean,matrix.type="edgelist")
	
	
	# coefficient for original net
	r_net = assort_coeff(net_clean)
	r_dev_q = 0
	r_vals = c()
	
	i = 1
	for( i in 1: n_edges) {

		net_i = network.copy(net_clean)
		edge_i = edgelist[i,]
		

		# remove i-th edge
		net_i[edge_i[1], edge_i[2]] = 0
			
		# calculate assort coeff
		r_i = assort_coeff(net_i)
		r_vals = append(r_vals, r_i)
		
		r_dev_q = r_dev_q + (r_i - r_net)^2
		
		i = i + 1
	}
	
	if(rvals == T) {
		return(r_vals)
	}
	
	r_dev = sqrt(r_dev_q)
	
	return(r_dev)
	
}

#
# delete edges to unknown nodes
#
del_u_edges <- function(net) {

	n_edges = length(as.matrix(net,matrix.type="edgelist")) / 2
	edgelist = as.matrix(net,matrix.type="edgelist")
	
	i = 1
	for( i in 1: n_edges) {

		edge_i = edgelist[i,]
		
		gender_x = get_gender(net, edge_i[1] )
		#print(gender_x)
		gender_y = get_gender(net, edge_i[2] )
		#print(gender_y)
		
		
		# check if a node if unknown gender is part of the edge, if true go to the next edge		
		if( gender_x == "u" ||  gender_y == "u") {
			net[edge_i[1], edge_i[2]] = 0
			#print("del")
			
		}
		
		i = i + 1
	}
	
	return(net)

}

degree_corr <- function(net) {
	n_edges = length(as.matrix(net,matrix.type="edgelist")) / 2
	edgelist = as.matrix(net,matrix.type="edgelist")
	deg = igraph::degree(to_igraph(net))
	x = c()
	y = c()
	
	i = 1
	for( i in 1: n_edges) {
		edge_i = edgelist[i,]
		
		# degree of connected nodes
		deg_x = deg[ edge_i[1] ]
		deg_y = deg[ edge_i[2] ]
	
		x = append(x, deg_x) 
		y = append(y, deg_y) 
	
		i = i + 1
	}
	
	dc = cov(x,y)/(sd(x)*sd(y))
	
	return(dc)
}

#
# Mann-Whitney test for degree distrubution by gender
#
mann_whitey_degree <- function(net) {

}

#
# randomize by fixed degreee sequence
#
rand_deg <- function(degrees, iterations = 100) {

	rand_graphs = c()
	
	i=0
	while ( i < iterations ) {
		rand_graph = degree.sequence.game(degrees, method="vl")
		rand_graphs = append(rand_graphs, rand_graph)
		i = i+1
	}

	return(rand_graphs)
}

#
# find interesting nodes over a stack of networks
# 
int_nodes_nets <- function(nets) {

	res = list()
	
	for(i in 1:length(nets)) {
		net_i = nets[[i]]
		super_n = int_nodes(net_i)
		
		super_n[["net"]] = net_i %n% "LABEL"
		
		res[[i]] = super_n
		
	}
	
	return(res)

}

#
# Find interesting nodes, such as the nodes have a hight betweenness bit are not cut-points which would components with size two or less
#
int_nodes <- function(net) {

	i_g = to_igraph(net)
	comps = igraph::clusters(i_g)
	
	sc_org = length(which(comps$csize < 3))
	cp = cutpoints(net)
	
	deg = degree(net, gmode="graph")
	bet = betweenness(net, gmode="graph")
	# get five highest betweenness values
	top_f_vals = c(sort( bet, decreasing=T))[0:5]
	
	in_top_f <- sapply(bet, function(x) x %in% top_f_vals)
	t_f = which(in_top_f == T) # the nodes in the top five
	
	sup_nodes = list()
	sup_nodes_indices = c();
	sup_nodes_labels = c()
	sup_nodes_sex = c()
	
	for ( i in 1:length(t_f)) {
		sup_node_index = t_f[i]
		nc = network.copy(net)
		#sex_v = c(nc %v% "SEX")
		#names_v = c(nc %v% "vertex.names")
		
		sup_node_label = c(nc %v% "vertex.names")[sup_node_index]
		
		sup_node_sex = c(nc %v% "SEX")[sup_node_index]
		
		
		delete.vertices(nc,sup_node_index) # delete vertex
		#delete.vertex.attribute(nc,"SEX") # adapt vertex names and sex to the deletion
		#delete.vertex.attribute(nc, "vertex.names")
		#sex_v = sex_v[-t_f[i]]
		#names_v = names_v[-t_f[i]]
		
		#set.vertex.attribute(nc, "SEX", sex_v)
		#set.vertex.attribute(nc, "vertex.names", names_v)
		
		igc = to_igraph(nc)

		compsc <- igraph::clusters(igc)
		sc_c = length(which(compsc$csize < 3)) # check if there are more components with size two or less
		
		
		if(sc_c == sc_org && deg[sup_node_index] != 1) { # nodes with degree 1 are not interesting
			
			sup_nodes_labels = append(sup_nodes_labels, sup_node_label)
			sup_nodes_indices = append(sup_nodes_indices, sup_node_index)
			sup_nodes_sex = append(sup_nodes_sex, sup_node_sex)
	
		}
	
	}
	
	sup_nodes[["indices"]]=sup_nodes_indices
	sup_nodes[["names"]]=sup_nodes_labels
	sup_nodes[["sex"]]=sup_nodes_sex
	
	return(sup_nodes)
	
	
}