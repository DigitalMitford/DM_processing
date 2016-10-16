import os
from Levenshtein import distance
os.chdir('/Users/ebb8/Documents/GitHub/mitford/drama-transformation')
file = open("LevDistsRienzi.txt", "w")
f = open('Rienzi_appText.txt')
f.readline() # read and ignore the first line
for line in f: # iterate over the remaining lines
	v = line.split('\t')
	dist1_2 = distance(v[1], v[2])
	dist1_3 = distance(v[1], v[3])
	dist1_4 = distance(v[1], v[4])
	dist2_3 = distance(v[2], v[3])
	dist2_4 = distance(v[2], v[4])
	dist3_4 = distance(v[3], v[4])
	file.write(''.join((v[0], '\t', 'MS::28:37:54: ', str(dist1_2), ', ', str(dist1_3), ', ', str(dist1_4), '\t', '28::MS:37:54: ', str(dist1_2), ', ', str(dist2_3), ', ', str(dist2_4), '\t', '37::MS:28:54: ', str(dist1_3), ', ', str(dist2_3), ', ', str(dist3_4), '\t', '54::MS:28:37: ', str(dist1_4), ', ', str(dist2_4), ', ', str(dist3_4), '\n')))
f.close()
file.close()		
		