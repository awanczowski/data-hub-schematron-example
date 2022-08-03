const schematron = require("/MarkLogic/schematron/schematron.xqy");
const validationUtils = require('/lib/validation-utils.xqy');

var contentArray;
var options;
var sch;

contentArray.forEach(content => {
    if (options.outputFormat == 'JSON') {
        const contentValue = content.value.toObject();
        let validation = schematron.validate(content.value, schematron.get(sch));

        let items = [];
        for (const item of validation.xpath('//*:failed-assert')) {
            items.push({
                'file': sch,
                'diagnostic': item.xpath('./*:diagnostic-reference/@diagnostic/data(.)'),
                'text': item.xpath('string-join(./(*:text|*:diagnostic-reference)/normalize-space(.), " ")')
            });
        }

        contentValue.envelope.headers.validation = contentValue.envelope.headers.validation || {};
        contentValue.envelope.headers.validation.schematron = items;

        content.value = contentValue;

        if (items.length > 0) {
            content.context.collections.push('validation-failed');
        } else {
            content.context.collections.push('validation-pass');
        }

    } else if (options.outputFormat == 'XML') {
        let envelope = validationUtils.build(sch, content.value);
        content.value = envelope;
        if (fn.exists(envelope.xpath('//validation/schematron/node()'))) {
            content.context.collections.push('validation-failed');
        } else {
            content.context.collections.push('validation-pass');
        }
    }
});