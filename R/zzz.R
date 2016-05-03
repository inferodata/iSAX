#.First.lib <- function(lib, pkg) library.dynam("sde", pkg, lib) 

#.noGenerics <- TRUE

.onAttach <- function(libname, pkgname)
{
    # require(methods)
 
    # require(zoo)
 packageStartupMessage("\n")
 packageStartupMessage(rep("#",63))
 packageStartupMessage("# iSA: U.S. provisional patent application No. 62/215264      #")
 packageStartupMessage("# This package is released under the Creative Commons License #")
 packageStartupMessage("# Attribution-NonCommercial-NoDerivatives 4.0 International   #")
 packageStartupMessage("# For academic use only!                                      #")
 packageStartupMessage(rep("#",63))
 packageStartupMessage("\n")
# require(KernSmooth, quietly=TRUE)
# library.dynam("yuima", pkgname, libname) 
}

