Get index statistics from most indexes. Statistics include index keys, frequency of the key in a data set and
across documents. The function supports the following indexes:

1. Structural index (frequency of elements and attributes in data set)
2. New range index
3. Lucene full text index
4. NGram index

# Usage

The following code prints a summary of all element and attribute names indexed for a given collection and shows the
frequency of each name in the collection and the number of documents it appears in:

```xquery
<elements>
{
    util:index-keys(collection("/db/test"), (),
        function($key, $count) {
            <element name="{$key}" count="{$count[1]}"
                docs="{$count[2]}"/>
        }, -1, "structural-index")
}
</elements>
```

To list all terms starting with the string "kin" in the lucene index for a given node set, use the following code:

```xquery
xquery version "3.0";

declare namespace tei="http://www.tei-c.org/ns/1.0";

<terms>
{
    util:index-keys(collection("/db/apps/shakespeare")//tei:sp, "kin", 
        function($key, $count) {
            <term name="{$key}" count="{$count[1]}"
                docs="{$count[2]}"/>
        }, -1, "lucene-index")
}
</terms>
```

Please note that the node set passed in the first argument does need to contain elements for which an index
had been defined (otherwise nothing will be returned).

# Index names

The default names for indexes are as follows:

Name|Index
----|-----
structural-index|Structural index
lucene-index|Lucene-based full text index
range-index|New range index