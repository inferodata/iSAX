## iSAX
iSAX is an R package which provides access to iSA algorithm technology presented in the paper "iSA: A fast, scalable and accurate algorithm for sentiment analysis of social media content", Information Sciences (2016). The paper is accessible following <a href="http://dx.doi.org/10.1016/j.ins.2016.05.052" target="_blank">this link</a>.

## Getting the R package
- Make sure to start a fresh R session and to have the devtools package installed, if not, please install it first with
  - `install.packages("devtools")`
. Then type:
  - `library(devtools)`
  - `install.packages(c("tm", "BMS", "quadprog", "rJava", "parallel", "data.table", "entropy"))`
  - `install_github("blogsvoices/iSAX")`
- At this point you should have `iSAX` installed and can proceed with:
  - `library(iSAX)`
- You should be ready to go!
- If you plan to use Chinese language, you'll also need the rmmseg4j package (easy)
- If you plan to use Japanese language, you'll also need RMeCab package (painful in many systems)

If rJava fails on OSX, please try to run on the Terminal window after installing the latest version of Java and reinstalling rJava package:

sudo R CMD javareconf

