<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="1.0">
    <sch:title>organization-validation</sch:title>
    <sch:phase id="phase1">
        <sch:active pattern="zip-code"></sch:active>
    </sch:phase>
    <sch:pattern id="zip-code">
        <sch:rule context="//Organization/headquarters/Address/zipCode">
            <sch:assert test="matches(., '(^[0-9]{5}$)|(^[0-9]{5}-[0-9]{4}$)')" diagnostics="d1" />
        </sch:rule>
    </sch:pattern>
    <sch:diagnostics>
        <sch:diagnostic id="d1">The zip code must match the 5 or 9 digit pattern with dashes.</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>