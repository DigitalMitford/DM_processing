import lxml.etree
#import lxml.builder 
import xml.etree.ElementTree as ET   

# E = lxml.builder.ElementMaker()
ROOT = ET.Element("root")
FIELD1 = ET.SubElement(ROOT, "field1", name='blah')
FIELD1.text = 'some value1'
FIELD2 = ET.SubElement(ROOT, "field2", name='moreBlah')
FIELD2.text = 'some value2'

#the_doc = ROOT(
 #       DOC(
#           FIELD1('some value1', name='blah'),
#            FIELD2('some value2', name='asdfasd'),
#           )   
 #       )   
#tree = the_doc
# s = lxml.etree.tostring(the_doc, pretty_print=True)
# with open('output.xml','wb') as f:
#	f.write(lxml.etree.tostring(ROOT, pretty_print=True))
tree = ET.ElementTree(ROOT)
tree.write('testOutput.xml')
