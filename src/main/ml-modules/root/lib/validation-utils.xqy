xquery version "1.0-ml";

(:~
: This module provides functionality for building out envelopes with Schematron vvalidation.
: 
: @author Drew Wanczowski
: @version 0.1
:)
module namespace utils = "http://marklogic.com/example/validation-utils";
 
declare namespace es = "http://marklogic.com/entity-services";
declare namespace svrl = "http://purl.oclc.org/dsdl/svrl";

import module namespace schematron = "http://marklogic.com/xdmp/schematron" 
      at "/MarkLogic/schematron/schematron.xqy";


(:~
 : Validates with provided schematron and builds envelope.
 :
 : @param $sch      - path to the schematron
 : @param $content  - entity services envelope
 :
 :)
declare function utils:build($sch as xs:string, $content as item()) as document-node() 
{
  (: This code is meant for illustrative purpose. :)
  document {
    <envelope xmlns="http://marklogic.com/entity-services">
      <headers>{($content/es:envelope/es:headers/node(), utils:validate($sch, $content))}</headers>
      <triples>{$content/es:envelope/es:triples/node()}</triples>
      <instance>{$content/es:envelope/es:instance/node()}</instance>
      <attachments>{$content/es:envelope/es:attachments/node()}</attachments>
    </envelope>
  }
};

(:~
 : Validates with provided schematron.
 :
 : @param $sch      - path to the schematron
 : @param $content  - entity services envelope
 :
 :)
declare private function utils:validate($sch as xs:string, $content as item()) {
   let $validation := schematron:validate($content, schematron:get($sch))
   let $results := 
        <validation>{
                for $item in $validation//svrl:failed-assert
                return 
                <schematron>
                    <file>{$sch}</file>
                    <diagnostic>{$item/svrl:diagnostic-reference/@diagnostic/data(.)}</diagnostic>
                    <text>{string-join($item/(svrl:text|svrl:diagnostic-reference)/normalize-space(.), " ")}</text>            
                </schematron>
        }</validation>
   return $results
};