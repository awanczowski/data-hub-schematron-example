<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="1.0">
  <sch:title>invoice-validation</sch:title>
  <sch:phase id="phase1">
    <sch:active pattern="category"></sch:active>
    <sch:active pattern="calculations"></sch:active>
  </sch:phase>
  <sch:pattern id="category">
    <sch:rule context="//Invoice/items/LineItem">
      <sch:assert test="('Metal', 'Stone', 'Wood','Glass','Steel','Plastic') = ./category" diagnostics="d1">
        Line Item <sch:value-of select="./lineNumber"/> is invalid. <sch:value-of select="./category"/> is not in the controlled list.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="calculations">
    <sch:rule context="//Invoice/items/LineItem">
      <sch:assert test="(quantity * unitPrice) = unitTotal" diagnostics="d2">
        Line Item <sch:value-of select="./lineNumber"/> is invalid.
      </sch:assert>
    </sch:rule>
    <sch:rule context="//Invoice">
      <sch:assert test="./total = sum(./items/LineItem/unitTotal)" diagnostics="d3" />
    </sch:rule>
  </sch:pattern>
  <sch:diagnostics>
    <sch:diagnostic id="d1">The category must be 'Metal','Stone', 'Wood','Glass','Steel', or 'Plastic'.</sch:diagnostic>
    <sch:diagnostic id="d2">The line item total must be calculated correctly.</sch:diagnostic>
    <sch:diagnostic id="d3">The invoice total sum is incorrect.</sch:diagnostic>
  </sch:diagnostics>
</sch:schema>