

#########  TMCMC  with and without diffeomorphism  ######################


d=50;  ##  dimension of the simulated variable
nsamples=20000;##  sample size in eahc iteration/ replication
L=30; ###   the number of replications we use for finding KS statistic
Diff_TMCMC=array(0,c(2,L,nsamples,d));


pdf = function(x) 
{
	sum=0;
	for (i in 1:d)
	{
	    sum=sum+dcauchy(x[i],location=0,scale=1,log=TRUE);
	}
	return(sum)
}


b1 <- morph(b=1);
pdf1<- b1$lud(function(x) pdf(x))

mu1=array(0,d); ###  mean of the proposal density (usually taken to be 0)
propvar=(2.4^2)/d;

# propvar=0.01;
Sigma1=sqrt(propvar)*diag(1,d);


prop_pdf=function(x) dmvnorm(x,mu1,Sigma1);


##############   Without  diffeomorphism (TMCMC)  ########################

for ( l in 1:L)
{
    smpl=matrix(0,nsamples,d);
    smpl[1,]=rnorm(d,10,1);
    i=2;
    counter2=0;
    while (i<=nsamples)
    {
       epsilon= abs(rnorm(1,mu1[1],Sigma1[1,1]));
	 y=array(0,d);
	 for (j in 1:d)
	 {
		w=runif(1)
		if(w<0.5)
		{y[j]= smpl[(i-1),j]+epsilon;}
		else {y[j]= smpl[(i-1),j]-epsilon;}
	 }

        accept_rate= min(1,exp(pdf(y)-pdf(smpl[(i-1),])));
        w=runif(1);
        if (w<accept_rate)
	  {
            smpl[i,]=y;
            i=i+1;
            counter2=counter2+1;
	  }
        else  {
            smpl[i,]=smpl[(i-1),];
            i=i+1;   }
    }

	# General[2,l,,]=apply(smpl,c(1,2),b1$inverse);
	Diff_TMCMC[1,l,,]=smpl;

}


#######################  With  Diffeomorphism  ############################


for ( l in 1:L)
{
    smpl=matrix(0,nsamples,d);
    smpl[1,]=rnorm(d,10,1);
    i=2;
    counter2=0;
    while (i<=nsamples)
    {
       epsilon= abs(rnorm(1,mu1[1],Sigma1[1,1]));
	 y=array(0,d);
	 for (j in 1:d)
	 {
		w=runif(1)
		if(w<0.5)
		{y[j]= smpl[(i-1),j]+epsilon;}
		else {y[j]= smpl[(i-1),j]-epsilon;}
	 }

        accept_rate= min(1,exp(pdf1(y)-pdf1(smpl[(i-1),])));
        w=runif(1);
        if (w<accept_rate)
	  {
            smpl[i,]=y;
            i=i+1;
            counter2=counter2+1;
	  }
        else  {
            smpl[i,]=smpl[(i-1),];
            i=i+1;   }
    }

	# General[2,l,,]=apply(smpl,c(1,2),b1$inverse);
	Diff_TMCMC[2,l,,]=smpl;

}


###########  Computing the KS distance between the iterations ##################

KSval_TMCMC_diff=array(0,nsamples);
KSval_TMCMC_wo_diff=array(0,nsamples);

for(d in 1:40)
{
	for(n in 1:nsamples)
	{
		simulate.vec=rcauchy(L,location=0,scale=1);
		simulate.vec2=b1$transform(simulate.vec);
		KSval_TMCMC_diff[n]=ks.test(Diff_TMCMC[2,,n,d],simulate.vec2)$statistic;
		KSval_TMCMC_wo_diff[n]=ks.test(Diff_TMCMC[1,,n,d],simulate.vec)$statistic;

	}


windows()
plot(1:nsamples,KSval_TMCMC_wo_diff,col="red",type="l",lwd=1,pch=2,xlab="",ylab="")
lines(1:nsamples,KSval_TMCMC_diff,col="blue",lwd=1,pch=3)
title(xlab="Time step of run");
title(ylab="KS test distance");
title(main="KS plot comparison TMCMC d=50");
legend("topright",c("with diffeomorphism","without diffeomorphism"),fill=c("red","blue"),border="black");


}





