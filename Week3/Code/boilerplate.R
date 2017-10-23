###############################################################################
# 7.13 Writing R Functions
###############################################################################


MyFunction <- function(Arg1, Arg2){

    # Statements involving Arg1, Arg2:
    # print Arg1's type
    print(paste("Argument", as.character(Arg1), "is a", class(Arg1)))
    # print Arg2's type
    print(paste("Argument", as.character(Arg2), "is a", class(Arg2)))

  return (c(Arg1, Arg2))  # this is optional but very useful
}

# Testing MyFunction
MyFunction(5,4)
MyFunction("David", "Bridgwood")


# Print the class of an object...

class(MyFunction)
