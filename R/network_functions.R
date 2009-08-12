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
node_level_values <- function (net, labelsOnly = FALSE) {

	values = c(network.size(net), count_attribute_occurance(net,"SEX","f") , count_attribute_occurance(net,"SEX","m"), count_attribute_occurance(net,"SEX","u"), network.density(net), network.edgecount(net))
	
	return(values)
}

#
# The labels (rows) fo the node level indices
#
node_level_labels <- function() {
	value_labels = c("Nodes", "Females", "Males", "Unknown", "Density", "Edges")
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
node_level_values_as_data_frame <- function(nets) {
	
	# the data frame
	indices_frame = data.frame(value_labels=node_level_labels() )
	
	for( i in 1:length(nets) ) {
		indices_frame[[nets[[i]] %n% "LABEL"]] <- factor( node_level_values(nets[[i]]) )
	}
	
	return(indices_frame)
}


