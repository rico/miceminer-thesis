#
# plot histogram of meeting duration for january 09
#
plot_meeting_dur_hist <- function(data) {
	
	meetings_hist = hist(unlist(data[1]), breaks=2000, plot=F,freq=F)
	plot(meetings_hist, xlim=c(60,800000),xlab="monthly meeting duration (s)",col="lightblue2",main="",freq=T)
	text(116566,180,"median: 32:10:01",col="olivedrab3",pos=4)
	abline(v = 164235, col = "orangered3", lty="dotdash")
	abline(v = 115801, col = "olivedrab3", lty="dotdash")
	text(165000,210,"mean: 45:37:15",col="orangered3",pos=4)
	
}

coerce_vector <- function(x) {

	y = c(0:(length(x) -1))
	z = c()

	i = 1
	for(i in 1:length(x)) {
		z = append(z, x[[i]])
		
		i = i + 1
	}
	
	m = cbind(y,z)
	
	return(m)

}


#
# calculate distribution
#
as_hist <- function(dat) {
	
	xy = matrix(c(sort(unique(dat)), rep(0,length(unique(dat))) ),length(unique(dat)),2)
	

	for(i in 1:length(dat)) {
		
		ind = which(xy[,1] == dat[i])
		xy[ind,2] = xy[ind,2] + 1
		
		i = i + 1
	}

	return(xy)

}

#
# plot longitudinal measures
#

long_plot <- function(values) {
		
		x_lim= c(min(values), max(values))
		
		# axis labels
		xlabs <- c( "Jun. `08", "Jul. `08", "Aug. `08", "Sept. `08", "Oct. `08", "Nov. `08", "Dec. `08", "Jan. `09", "Feb. `09", "Mar. `09", "Apr. `09" , "May `09", "Jun. `09")
		
		# plot command 	
		par(mar = c(6, 5, 4, 2));
		par(mgp = c(0,3,2)) ; 
		plot(values, type="b", pch=20, col="royalblue", xlab="month", ylab="nodes", yaxt="n",xaxt="n", bty="l", las=1, lwd=2, fg=grey(0.7)) ;
		axis(1, labels=xlabs, at=c(1:length(xlabs)), cex.axis=0.75, las=2);
		axis(2)
}




