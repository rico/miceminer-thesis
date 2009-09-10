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


