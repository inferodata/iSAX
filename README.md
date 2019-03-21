## iSAX
iSAX is an R package which provides access to iSA technology developed by <a href="http://www.voices-int.com" target="_blank">VOICES from the Blogs</a>. It is released for academic use only and licensed under the <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/" target="_blank">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License <img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/80x15.png" /></a>.

## iSAX's background
The iSA/iSAX algorithms have been presented in the paper "iSA: A fast, scalable and accurate algorithm for sentiment analysis of social media content", Information Sciences (2016). The paper is accessible following <a href="http://dx.doi.org/10.1016/j.ins.2016.05.052" target="_blank">this link</a>.


## Warning:
Commercial use of iSA is protected under the U.S. provisional patent application No. 62/215264

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
- If you have any question or you are interested in using iSA technology in an enterprise environment, please contact us at iSA@voices-int.com

If rJava fails on OSX, please try to run on the Terminal window after installing the latest version of Java and reinstalling rJava package:

sudo R CMD javareconf

