import lxml.etree
import lxml.builder    

E = lxml.builder.ElementMaker()
ROOT = E.root
DOC = E.doc
FIELD1 = E.field1
FIELD2 = E.field2

the_doc = ROOT(
        DOC(
            FIELD1('some value1', name='blah'),
            FIELD2('some value2', name='asdfasd'),
            )   
        )   
tree = the_doc
# s = lxml.etree.tostring(the_doc, pretty_print=True)
with open('output.xml','wb') as f:
	f.write(lxml.etree.tostring(the_doc, pretty_print=True))