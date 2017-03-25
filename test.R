



check_list <- c("BHC-gamma (Lindane)","BHC - gamma (lindane)","Lindane")

pref_rep <- length(check_list)

pref <- rep("HCH-gamma (Lindane)", pref_rep)

list <- c("HCH-gamma (Lindane)","BHC-gamma (Lindane)","BHC - gamma (lindane)","Lindane","HCH-gamma (Lindane)","BHC-gamma (Lindane)","BHC - gamma (Lindane)")



mgsub <- function(pattern, replacement, x, ...) {
  n=length(pattern)
  result = x
  for (i in 1:n) {
    result[grep(pattern[i], x, ignore.case = TRUE, ...)] = replacement[i]
  }
  return(result)
}

mgsub(check_list, pref, list)



