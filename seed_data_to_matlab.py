# seed_data_to_matlab.py
# create seed data from seed text file
import scipy.io

# for converting strings to numbers
def num(s):
    try:
        if '.' in s:
            return float(s)
        else:
            return int(s)
    except ValueError:
        return s


# open file
filename = 'seeds_dataset.txt'
file = open(filename, 'r')

# strip out newlines and split on tabs
data = [line.rstrip().split('\t') for line in file]
# convert strings to numbers
data = [[num(j) for j in i if j] for i in data]
file.close()

# save for matlab
scipy.io.savemat('seed_data.mat', mdict={'seed_data': data})
