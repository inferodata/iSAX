#########################################################################################################
# iSAX is an R package which provides access to iSA technology developed by 
# VOICES from the Blogs. It is released for academic use only and licensed 
# under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License 
# see http://creativecommons.org/licenses/by-nc-nd/4.0/
# Warning: Commercial use of iSA is protected under the U.S. provisional patent application No. 62/215264
#########################################################################################################

prep.data <- function(corpus, th=0.99, lang="english", train=NULL,
    use.all=TRUE, shannon=FALSE, verbose=FALSE,
    stripWhite=TRUE, removeNum=TRUE, removePunct=TRUE,
    removeStop=TRUE, toPlain=TRUE, doGC=FALSE){
    mc <- min(2, as.integer(detectCores()/2))
    options(mc.cores = mc)
    
    JP <- lang == "japanese"
    CN <- lang == "chinese"
    
    if(JP){
        require(RMeCab)
        if(verbose)
        cat("Phase1: Japanese tokenization...")
        tkz <- function(x) iconv(paste(RMeCabC(x$content),collapse=" "),"UTF-8", sub="byte")
        
        corpus <- tm_map(corpus, tkz)
            if(stripWhite){
                if(verbose) cat("strip white...")
                corpus <- tm_map(corpus, stripWhitespace)
            }
            if(removeNum){
                if(verbose) cat("remove numbers...")
                corpus <- tm_map(corpus, removeNumbers)
            }
            if(removePunct){
                if(verbose) cat("remove punctuation...")
                corpus <- tm_map(corpus, removePunctuation)
            }
            if(removeStop){
                if(verbose) cat("remove English stopwords...")
                corpus <- tm_map(corpus, removeWords, stopwords("english"))
            }
            if(toPlain){
                if(verbose) cat("sanitizing corpus...")
                corpus <- tm_map(corpus, PlainTextDocument)
            }
        
    }
    
    if(CN){
        library(rmmseg4j)
        if(verbose) cat("Phase1: Chinese tokenization...")
        tkz <- function(x)  {y <- mmseg4j(x$content); Encoding(y) <- "UTF-8"; y
        }
        tmp <- lapply(corpus, tkz)
        corpus <- VCorpus(VectorSource(tmp),readerControl=list(language="zh"))
        rm(tmp)
        if(removeNum){
            if(verbose) cat("remove numbers...")
            corpus <- tm_map(corpus, removeNumbers)
        }
        if(removePunct){
            if(verbose) cat("remove punctuation...")
            corpus <- tm_map(corpus, removePunctuation)
        }
        if(stripWhite){
            if(verbose) cat("strip white...")
            corpus <- tm_map(corpus, stripWhitespace)
        }
        if(removeStop){
            if(verbose) cat("remove English stopwords...")
            corpus <- tm_map(corpus, removeWords, stopwords("english"))
        }
        if(toPlain){
            if(verbose) cat("sanitizing corpus...")
            corpus <- tm_map(corpus, PlainTextDocument)
        }
    }
    
    if(!CN & !JP){
        if(verbose) cat("Phase1: Cleaning up...")
        tl <- function(x)  iconv(x$content,"UTF-8", sub="byte")
        tmp <- lapply(corpus, tl)
        corpus <- VCorpus(VectorSource(tmp))
        rm(tmp)
        
        
        #if(removeStop){
        #    if(verbose) cat("remove English stopwords...")
        #    corpus <- tm_map(corpus, removeWords, stopwords("english"))
        #    if(verbose) cat("remove Italian stopwords...")
        #    corpus <- tm_map(corpus, removeWords, stopwords("italian"))
        #}
        
        if(toPlain){
            if(verbose) cat("sanitizing corpus...")
            corpus <- tm_map(corpus, PlainTextDocument)
        }
    }
    if(verbose) cat("Phase2: stemming...")
    if(!JP)
    gc(doGC,doGC)
    
    if(CN | JP){
        dtm <- DocumentTermMatrix(corpus, control=list(tolower=FALSE))
    } else {
        if(stripWhite){
            if(verbose) cat("strip white spaces...")
            corpus <- tm_map(corpus, stripWhitespace)
        }
        dtm <- DocumentTermMatrix(corpus, control=list(mc.cores=mc,
        removePunctuation=removePunct, stopwords=removeStop, removeNumbers=removeNum, tolower=TRUE, stemming=TRUE, 
          weighting=weightBin, language=lang))
    }
    rm(corpus)
    if(!JP)
    gc(doGC,doGC)
    
    #    dtm[dtm>1] <- 1
    if(!use.all){
        if(shannon){
            sh <-  apply(dtm[train,], 2, entropy)
            idx <- which(sh>quantile(sh,pr=th, na.rm=TRUE))
            dtm2.train  <- dtm[train,idx]
            dtm3.train <- as.matrix(dtm2.train)
        } else {
            dtm2.train  <- removeSparseTerms(dtm[train,], th)
            dtm3.train <- as.matrix(dtm2.train)
        }
    }
    
    
    if(shannon){
        dtm1 <- removeSparseTerms(dtm, th)
        sh <-  apply(dtm1, 2, entropy)
        idx <- which(sh>quantile(sh,pr=th, na.rm=TRUE))
        dtm2.full  <- dtm1[,idx]
        dtm3.full <- as.matrix(dtm2.full)
    } else {
        dtm2.full <- removeSparseTerms(dtm, th)
        dtm3.full <- as.matrix(dtm2.full)
    }
    
    if(!use.all){
        idx <- match(colnames(dtm3.train), colnames(dtm3.full))
        idx <- idx[!is.na(idx)]
        dtm3.full <- dtm3.full[, idx]
    }
    dtm3.full[dtm3.full>1] <- 1
    if(verbose) cat("Phase3: bin2hexing...")
    
    S <- apply(dtm3.full, 1, bin2hex)
    
    return(list(S=S, dtm=dtm3.full, train=train, th=th))
}

