import os
import lxml.etree
# import lxml.builder
# E = lxml.builder.ElementMaker()
import xml.etree.ElementTree as ET
from Levenshtein import distance
os.chdir('/Users/ebb8/Documents/GitHub/mitford/drama-transformation')

Root = ET.Element("xml")
Table = ET.SubElement(Root, "table")
THRow = ET.SubElement(Table, "tr", id="head")
TH1 = ET.SubElement(THRow, "th")
TH1.text = "Locus"
TH2 = ET.SubElement(THRow, "th")
TH2.text = "MS to 1828"
TH3 = ET.SubElement(THRow, "th")
TH3.text = "MS to 1837"
TH4 = ET.SubElement(THRow, "th")
TH4.text = "MS to 1854"
TH5 = ET.SubElement(THRow, "th")
TH5.text = "1828 to 1837"
TH6 = ET.SubElement(THRow, "th")
TH6.text = "1828 to 1854"
TH7 = ET.SubElement(THRow, "th")
TH7.text = "1837 to 1854"

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
	TR = ET.SubElement(Table, "tr")
	TD1 = ET.SubElement(TR, "td")
	TD1.text = v[0]
	TD2 = ET.SubElement(TR, "td")
	TD2.text = str(dist1_2)
	TD3 = ET.SubElement(TR, "td")
	TD3.text = str(dist1_3)
	TD4 = ET.SubElement(TR, "td")
	TD4.text = str(dist1_4)
	TD5 = ET.SubElement(TR, "td")
	TD5.text = str(dist2_3)
	TD6 = ET.SubElement(TR, "td")
	TD6.text = str(dist2_4)
	TD7 = ET.SubElement(TR, "td")
	TD7.text = str(dist3_4)
	
#with open('LevDistsRienzi.xml','wb') as g:
#	g.write(lxml.etree.tostring(the_doc, pretty_print=True))
#print lxml.etree.tostring(the_doc, pretty_print=True)
tree = ET.ElementTree(Root)
tree.write('LevDistsRienzi.xml')
f.close()

	#TRl = E.tr
	#TD = E.td
	#the_loop = TRl(
	#TD(dist1_2),
	#TD(dist1_3),
	#TD(dist1_4),
	#TD(dist2_3),
	#TD(dist2_4),
	#TD(dist3_4)
	#)
	    	
#the_doc = Root(
 #       	Table(
#        TR(TH('Locus'), TH('MS to 1828'), TH('MS to 1837'), TH('MS to 1854'), TH('1828 to 1837'), TH('1828 to 1854'), TH('1837 to 1854'))
		
	#	the_loop 
		#ebb: having trouble making a nested loop in constructed XML output. Running this produces a fatal error at this line. 
		#If I position the_doc and this tree builder to surround the for loop, this errors on the "for line in f:"
		#Does the for-loop and its dependents belong in a function?
        
     #   )
           
       # )  	
		