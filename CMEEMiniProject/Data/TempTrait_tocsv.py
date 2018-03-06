import csv

txt_file = "TempTrait_001.txt"
csv_file = "TempTrait_001.csv"



with open(txt_file, "r", encoding="utf8", errors='ignore') as in_txt:
    read = csv.reader(in_txt, delimiter = '\t')
    out_csv = csv.writer(open(csv_file, 'w'))
    out_csv.writerows(in_txt)
