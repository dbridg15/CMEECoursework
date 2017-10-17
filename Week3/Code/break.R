i <- 0  # initialise i
    while(i < Inf){
        if (i == 20){
            break }  # break out of the loop!
        else {
            cat("i equals ", i, " \n")
            i <- i +1  # update i
        }
    }

for(i in 1:10){
    if((i %% 2) == 0)
        next  # pass to the next iteration
    print(i)
}

