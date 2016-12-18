xquery version "3.0";

(:
 : Copyright (c) 2010-2011
 :     John Snelson. All rights reserved.
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :     http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)

(:
 Adam Retter 20121227 patched parseArray and parseObject functions to
 support empty arrays and empty objects
:)

module namespace jsjson = "http://johnsnelson/json";

(:----------------------------------------------------------------------------------------------------:)
(: JSON parsing :)

declare function jsjson:parse-json($json as xs:string)
  as element()?
{
  let $res := jsjson:parseValue(jsjson:tokenize($json))
  return
    if(exists(remove($res,1))) then jsjson:parseError($res[2])
    else element json {
      $res[1]/@*,
      $res[1]/node()
    }
};

declare %private function jsjson:parseValue($tokens as element(token)*)
{
  let $token := $tokens[1]
  let $tokens := remove($tokens,1)
  return
    if($token/@t = "lbrace") then (
      let $res := jsjson:parseObject($tokens)
      let $tokens := remove($res,1)
      return (
        element res {
          attribute type { "object" },
          $res[1]/node()
        },
        $tokens
      )
    ) else if ($token/@t = "lsquare") then (
      let $res := jsjson:parseArray($tokens)
      let $tokens := remove($res,1)
      return (
        element res {
          attribute type { "array" },
          $res[1]/node()
        },
        $tokens
      )
    ) else if ($token/@t = "number") then (
      element res {
        attribute type { "number" },
        text { $token }
      },
      $tokens
    ) else if ($token/@t = "string") then (
      element res {
        attribute type { "string" },
        text { jsjson:unescape-json-string($token) }
      },
      $tokens
    ) else if ($token/@t = "true" or $token/@t = "false") then (
      element res {
        attribute type { "boolean" },
        text { $token }
      },
      $tokens
    ) else if ($token/@t = "null") then (
      element res {
        attribute type { "null" }
      },
      $tokens
    ) else jsjson:parseError($token)
};

declare %private function jsjson:parseObject($tokens as element(token)*)
{
  let $token1 := $tokens[1]
  let $tokens := remove($tokens,1)
  return
    if($token1/@t eq "rbrace")then (
        element res {
        },
        $tokens
    ) else if(not($token1/@t = "string")) then jsjson:parseError($token1) else
      let $token2 := $tokens[1]
      let $tokens := remove($tokens,1)
      return
        if(not($token2/@t = "colon")) then jsjson:parseError($token2) else
          let $res := jsjson:parseValue($tokens)
          let $tokens := remove($res,1)
          let $pair := element pair {
            attribute name { $token1 },
            $res[1]/@*,
            $res[1]/node()
          }
          let $token := $tokens[1]
          let $tokens := remove($tokens,1)
          return
            if($token/@t = "comma") then (
              let $res := jsjson:parseObject($tokens)
              let $tokens := remove($res,1)
              return (
                element res {
                  $pair,
                  $res[1]/node()
                },
                $tokens
              )
            ) else if($token/@t = "rbrace") then (
              element res {
                $pair
              },
              $tokens
            ) else jsjson:parseError($token)
};

declare %private function jsjson:parseArray($tokens as element(token)*)
{
  if($tokens[1]/@t = "rsquare") then (
    (: empty array! :)
    
    element res {},
    remove($tokens, 1)
  ) else
    let $res := jsjson:parseValue($tokens)
    let $tokens := remove($res,1)
    let $item := element item {
      $res[1]/@*,
      $res[1]/node()
    }
    let $token := $tokens[1]
    let $tokens := remove($tokens,1)
    return
      if($token/@t = "comma") then (
        let $res := jsjson:parseArray($tokens)
        let $tokens := remove($res,1)
        return (
          element res {
            $item,
            $res[1]/node()
          },
          $tokens
        )
      ) else if($token/@t = "rsquare") then (
        element res {
          $item
        },
        $tokens
      ) else jsjson:parseError($token)
};

declare %private function jsjson:parseError($token as element(token))
  as empty-sequence()
{
  error(xs:QName("jsjson:PARSEJSON01"),
    concat("Unexpected token: ", string($token/@t), " (""", string($token), """)"))
};

declare %private function jsjson:tokenize($json as xs:string)
  as element(token)*
{
  let $tokens := ("\{", "\}", "\[", "\]", ":", ",", "true", "false", "null", "\s+",
    '"([^"\\]|\\"|\\\\|\\/|\\b|\\f|\\n|\\r|\\t|\\u[A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9])*"',
    "-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][-+]?[0-9]+)?")
  let $regex := string-join(for $t in $tokens return concat("(",$t,")"),"|")
  for $match in analyze-string($json, $regex)/*
  return
    if($match/self::*:non-match) then jsjson:token("error", string($match))
    else if($match/*:group/@nr = 1) then jsjson:token("lbrace", string($match))
    else if($match/*:group/@nr = 2) then jsjson:token("rbrace", string($match))
    else if($match/*:group/@nr = 3) then jsjson:token("lsquare", string($match))
    else if($match/*:group/@nr = 4) then jsjson:token("rsquare", string($match))
    else if($match/*:group/@nr = 5) then jsjson:token("colon", string($match))
    else if($match/*:group/@nr = 6) then jsjson:token("comma", string($match))
    else if($match/*:group/@nr = 7) then jsjson:token("true", string($match))
    else if($match/*:group/@nr = 8) then jsjson:token("false", string($match))
    else if($match/*:group/@nr = 9) then jsjson:token("null", string($match))
    else if($match/*:group/@nr = 10) then () (:ignore whitespace:)
    else if($match/*:group/@nr = 11) then
      let $v := string($match)
      let $len := string-length($v)
      return jsjson:token("string", substring($v, 2, $len - 2))
    else if($match/*:group/@nr = 13) then jsjson:token("number", string($match))
    else jsjson:token("error", string($match))
};

declare %private function jsjson:token($t, $value)
{
  <token t="{$t}">{ string($value) }</token>
};

(:----------------------------------------------------------------------------------------------------:)
(: JSON serializing :)

declare function jsjson:serialize-json($json-xml as element()?)
  as xs:string?
{
  if(empty($json-xml)) then () else

  string-join(
    jsjson:serializeJSONElement($json-xml)
  ,"")
};

declare %private function jsjson:serializeJSONElement($e as element())
  as xs:string*
{
  if($e/@type = "object") then jsjson:serializeJSONObject($e)
  else if($e/@type = "array") then jsjson:serializeJSONArray($e)
  else if($e/@type = "null") then "null"
  else if($e/@type = "boolean") then string($e)
  else if($e/@type = "number") then string($e)
  else ('"', jsjson:escape-json-string($e), '"')
};

declare %private function jsjson:serializeJSONObject($e as element())
  as xs:string*
{
  "{",
  $e/*/(
    if(position() = 1) then () else ",",
    '"', jsjson:escape-json-string(@name), '":',
    jsjson:serializeJSONElement(.)
  ),
  "}"
};

declare %private function jsjson:serializeJSONArray($e as element())
  as xs:string*
{
  "[",
  $e/*/(
    if(position() = 1) then () else ",",
    jsjson:serializeJSONElement(.)
  ),
  "]"
};

(:----------------------------------------------------------------------------------------------------:)
(: JSON unescaping :)

declare function jsjson:unescape-json-string($val as xs:string)
  as xs:string
{
  string-join(
    let $regex := '[^\\]+|(\\")|(\\\\)|(\\/)|(\\b)|(\\f)|(\\n)|(\\r)|(\\t)|(\\u[A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9])'
    for $match in analyze-string($val, $regex)/*
    return
      if($match/*:group/@nr = 1) then """"
      else if($match/*:group/@nr = 2) then "\"
      else if($match/*:group/@nr = 3) then "/"
      (: else if($match/*:group/@nr = 4) then "&#x08;" :)
      (: else if($match/*:group/@nr = 5) then "&#x0C;" :)
      else if($match/*:group/@nr = 6) then "&#x0A;"
      else if($match/*:group/@nr = 7) then "&#x0D;"
      else if($match/*:group/@nr = 8) then "&#x09;"
      else if($match/*:group/@nr = 9) then
        codepoints-to-string(jsjson:decode-hex-string(substring($match, 3)))
      else string($match)
  ,"")
};

declare function jsjson:escape-json-string($val as xs:string)
  as xs:string
{
  string-join(
    let $regex := '(")|(\\)|(/)|(&#x0A;)|(&#x0D;)|(&#x09;)|[^"\\/&#x0A;&#x0D;&#x09;]+'
    for $match in analyze-string($val, $regex)/*
    return
      if($match/*:group/@nr = 1) then "\"""
      else if($match/*:group/@nr = 2) then "\\"
      else if($match/*:group/@nr = 3) then "\/"
      else if($match/*:group/@nr = 4) then "\n"
      else if($match/*:group/@nr = 5) then "\r"
      else if($match/*:group/@nr = 6) then "\t"
      else string($match)
  ,"")
};
declare function jsjson:decode-hex-string($val as xs:string)
  as xs:integer
{
  jsjson:decodeHexStringHelper(string-to-codepoints($val), 0)
};

declare %private function jsjson:decodeHexChar($val as xs:integer)
  as xs:integer
{
  let $tmp := $val - 48 (: '0' :)
  let $tmp := if($tmp <= 9) then $tmp else $tmp - (65-48) (: 'A'-'0' :)
  let $tmp := if($tmp <= 15) then $tmp else $tmp - (97-65) (: 'a'-'A' :)
  return $tmp
};

declare %private function jsjson:decodeHexStringHelper($chars as xs:integer*, $acc as xs:integer)
  as xs:integer
{
  if(empty($chars)) then $acc
  else jsjson:decodeHexStringHelper(remove($chars,1), ($acc * 16) + jsjson:decodeHexChar($chars[1]))
};
