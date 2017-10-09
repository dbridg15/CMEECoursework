import csv

# Read a file containing:
# 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male (kg)'
with open('../Sandbox/testcsv.csv','r') as f:

    csvread = csv.reader(f)
    temp = []
    for row in csvread:
        temp.append(tuple(row))
        print(row)
        print("The species is", row[0])

# Write a file containing only species namd and Body mass
with open('../Sandbox/testcsv.csv','r') as f:
    with open('../Sandbox/bodymass.csv', 'w') as g:

        csvread = csv.reader(f)
        csvwrite = csv.writer(g)
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0],row[4]])

