For an extended description of the picture string, see the documentation and examples in the XQuery function
[specification](http://www.w3.org/TR/xpath-functions-30/#rules-for-datetime-formatting).

# Examples

format-date($d, "\[Y0001] \[M01]-\[D01]") | 2014-02-22

format-date($d, "\[D1o] \[MNn], \[Y]", "en", (), ()) | 22nd February, 2014

format-date($d, "\[MNn] \[D], \[Y]", "en", (), ()) | February 22, 2014
