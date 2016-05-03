iSA <-
function(Strain, Stest, Dtrain, nboot=1000, predict=FALSE, ret.boot=FALSE, seqlen=5, sparse=FALSE, verbose=TRUE){
    ptm <- proc.time()
    #  require(quadprog)
    #require(data.table)
    
    ptable <- function(x)
    {
        a <- data.table(x)
        b <-  a[, .N, by=x]
        tmp <- b$N
        names(tmp) <- b$x
        return(tmp/sum(tmp))
    }
    
    if(verbose)
    cat("\niSAX...\n")
    
    
    S <- c(Strain,Stest)
    
    D <- c(Dtrain, rep(NA, length(Stest)))
    
    nc <- nchar(S[1])
    if(seqlen>0){

        if(nc<=3)
            seqlen <- 1
        if(nc>10 & seqlen<3)
            seqlen <- 3
        if(seqlen>=nc)
            seqlen <- nc

        nseq <- floor(nc/seqlen)
    
        splits <- cumsum(rep(seqlen,nseq))
        nsplits <- length(splits)
    
        if(splits[nsplits] > nc-2){
            splits[nsplits] <- nc
        } else {
            splits <- c(splits,nc)
        }
        nsplits <- length(splits)
        lS <- length(S)
        newS <- character(nsplits * lS)
    
        if(nsplits>2){
        
            newS[1:lS] <- paste0(letters[1],substr(S,1,splits[1]))
        
            for(i in 1:(nsplits-1)){
                newS[(lS*i+1):(lS*(i+1))] <- paste0(letters[i+1],substr(S,splits[i]+1,splits[i+1]))
            }
            newD <- rep(D, nsplits)
            D <- newD
            S <- newS
        }
    }
    
    idd <- which(is.na(D))
    Strain <- S[-idd]
    Dtrain <- D[-idd]
    
    # distribuzione di D nel training set
    pD.train <- ptable(Dtrain)


    # distribuzione complessiva di S
    pS <- ptable(S)
    nS <- names(pS) # stem names
    lS <- length(pS) # number of unique stems
    
    if(sparse){
     prSD <- xtabs(~ Strain + Dtrain, sparse=sparse)
     sums <- apply(prSD,2,sum)
     for(i in 1:ncol(prSD))
      prSD[,i] <- prSD[,i]/sums[i]
    } else {
     prSD <- prop.table(table(Strain,Dtrain),2)
    }

    lD <- ncol(prSD)
    nD <- colnames(prSD)
    nSD <- rownames(prSD)
    
    P <- matrix(0,  nrow=lS, ncol=lD) #, dimnames=list(nS,nD))

    idx <- match(nSD, nS )
    P[idx, ] <- as.numeric(prSD)

    tb <- matrix(, lD, 4)
    rownames(tb) <- nD
    colnames(tb) <- c("Estimate", "Std. Error", "z value", "Pr(>|z|)")
    
    tmp <- matrix(,lD,1)
    colnames(tmp) <- "iSA"
    rownames(tmp) <- nD
    
    
    # contrained iSA
    q <- ncol(P)
    ind <- matrix(0, q, 2)
    rownames(ind) <- nD
    ind[, 1] <- 1
    q0 <- ncol(P)
    Amat <- matrix(0, q0, q0 * 2 + 1)
    Amat[, 1] <- rep(1, q0)
    Amat[, 2:(q0 + 1)] <- diag(1, q0)
    Amat[, (q0 + 2):(2 * q0 + 1)] <- diag(-1, q0)
    lbd <- rep(0, q)
    ubd <- rep(1, q)
    const <- 1
    bvec <- c(const, lbd[ind[, 1] == 1], -ubd[ind[, 1] == 1])
    
    aa <- try(solve.QP(t(P)%*% P, t(pS) %*% P, Amat,bvec, meq = 1), TRUE)
    if(class(aa) == "try-error"){
        b <- rep(NA, q0)
    } else {
        b <-aa$solution
    }
    sigma2 <- sum((pS - as.numeric(P %*% b))^2)/(length(pS)-ncol(P)-1)
    qp <- tmp
    qp[,1] <- b
    colnames(qp) <- "iSA"
    tabc <- tb
    tabc[,1] <- qp[,1]
    serr <- try(sqrt(sigma2 * diag(solve(t(P)%*% P))), TRUE)
    if(class(serr)=="try-error")
    serr <- rep(NA, q0)
    tabc[,2] <- serr
    tabc[,3] <- tabc[,1]/tabc[,2]
    tabc[,4] <- pnorm(tabc[,3],lower.tail=FALSE)*2
  
    boot <- NULL
    
    if(nboot>0){
        if(verbose)
        cat("\nbootstrapping...please wait")
        for(i in 1:nboot){
            idx <- sample(1:length(pS), length(pS), replace=TRUE)
            tP <- P[idx,]
            tpS <- pS[idx]
            aa <- try(solve.QP(t(tP)%*% tP, t(tpS) %*% tP, Amat,bvec, meq = 1),TRUE)
            b <- rep(NA, q0)
            if(class(aa) != "try-error"){
                b <-aa$solution
            }
            boot <- rbind(boot, b)
        }
        
        if(verbose)
        cat("\n")
        b.cf <- tmp
        b.cf[,1] <- colMeans(boot,na.rm=TRUE)
        colnames(b.cf) <- "iSAb"
        b.sd <- apply(boot,2, function(u) sd(u, na.rm=TRUE))
        #print(b.sd)
        b.t <- NA
        if(!is.na(sum(b.sd)))
        b.t <- b.cf/b.sd
        
        
        tabb <- tb
        tabb[,1] <- b.cf
        tabb[,2] <- b.sd
        tabb[,3] <- b.t
        tabb[,4] <- pnorm(tabb[,3],lower.tail=FALSE)*2
    } else {
        tabb <- tabc
        b.cf <- qp
    }
    
    predict.iSA <- function(x){
        
        idx <- match(x, nS)
        sapply(idx, function(i) which.max(sapply(1:lD,function(x) P[i,x]*b.cf[x]/pS[i]))) -> aa
        nD[aa]
    }
    
    pred <- NULL
    if(predict){
        pred <- predict.iSA(S)
    }
    etime <- (proc.time()-ptm)[1]
    if(verbose)
    cat(sprintf("\nElapsed time: %.2f seconds\n",etime))
    if(ret.boot)
     return(list( est=qp, tab=tabc, best=b.cf, btab=tabb, boot=boot, pred=pred,time=etime ) )
    return(list( est=qp, tab=tabc, best=b.cf, btab=tabb, boot=NULL, pred=pred,time=etime ) )
}
