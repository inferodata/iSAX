#########################################################################################################
# iSAX is an R package which provides access to iSA technology developed by 
# VOICES from the Blogs. It is released for academic use only and licensed 
# under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License 
# see http://creativecommons.org/licenses/by-nc-nd/4.0/
# Warning: Commercial use of iSA is protected under the U.S. provisional patent application No. 62/215264
#########################################################################################################

.onAttach <- function(libname, pkgname)
{
 packageStartupMessage("\n")
 packageStartupMessage(rep("#",63))
 packageStartupMessage("# iSA: U.S. provisional patent application No. 62/215264      #")
 packageStartupMessage("# This package is released under the Creative Commons License #")
 packageStartupMessage("# Attribution-NonCommercial-NoDerivatives 4.0 International   #")
 packageStartupMessage("# For academic use only!                                      #")
 packageStartupMessage(rep("#",63))
 packageStartupMessage("\n")
}

