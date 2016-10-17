import os
import lxml.etree
import lxml.builder
from Levenshtein import distance
os.chdir('/Users/ebb8/Documents/GitHub/mitford/drama-transformation')
E = lxml.builder.ElementMaker()
Root = E.xml
Table = E.table
TR = E.tr
TH = E.th


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
	TRl = E.tr
	TD = E.td
	the_loop = TRl(
	TD(dist1_2),
	TD(dist1_3),
	TD(dist1_4),
	TD(dist2_3),
	TD(dist2_4),
	TD(dist3_4)
	)
	    	
the_doc = Root(
        	Table(
        TR(TH('Locus'), TH('MS to 1828'), TH('MS to 1837'), TH('MS to 1854'), TH('1828 to 1837'), TH('1828 to 1854'), TH('1837 to 1854'))
		
		the_loop 
		#ebb: having trouble making a nested loop in constructed XML output. Running this produces a fatal error at this line. 
		#If I position the_doc and this tree builder to surround the for loop, this errors on the "for line in f:"
		#Does the for-loop and its dependents belong in a function?
        
        )
           
        )  
	

with open('LevDistsRienzi.xml','wb') as g:
	g.write(lxml.etree.tostring(the_doc, pretty_print=True))
#print lxml.etree.tostring(the_doc, pretty_print=True)
f.close()

		
		