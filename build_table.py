import glob
import re


def convert(name):
    name = name.split(".")[0]
    name = name.split("/")[-1]
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1 \2', name)
    name = re.sub('([a-z0-9])([A-Z])', r'\1 \2', s1).lower().split(" ")
    return name[0].capitalize()+name[1]+" "+name[-1].upper()


table = []

for path in sorted(glob.glob("data/*.csv")):
    with open(path) as fl:
        contents = list(filter(lambda l: l != "", fl.read().split("\n")))
        print(path,list(contents))
    if not table:
        # Build first column
        table = [["Operations"]+[line.split(", ")[0] for line in contents]]
    print(path,list(contents))
    table.append([convert(path)]+[round(float(line.split(", ")[1])*1000,4) for line in contents])


for ln in range(len(table[0])):
    #print([str(col[ln]) for col in table])
    #print(list([len(col) for col in table]))
    vals = ", ".join([str(col[ln]) for col in table])
    print(vals)
