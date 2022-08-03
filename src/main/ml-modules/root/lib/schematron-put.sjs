const schematron = require("/MarkLogic/schematron/schematron.xqy");

declareUpdate();

xdmp.invokeFunction(putSchematrons, {
  "userId": xdmp.user('demo-user')
});

function putSchematrons() {
  xdmp.log('Starting Putting Schematrons...');

  const params =
  {
    "phase": "#ALL",
    "terminate": false,
    "generate-fired-rule": true,
    "generate-paths": true,
    "diagnose": true,
    "allow-foreign": false,
    "validate-schema": true
  }

  let schematrons = xdmp.invokeFunction(getSchematrons, {
    database: xdmp.schemaDatabase(xdmp.database())
  });

  schematrons
    .toArray()
    .forEach(uri => {
      xdmp.log('Putting Schematron: ' + uri);
      schematron.put(uri, params);
    });

  xdmp.log('Done Putting Schematrons...');
}

function getSchematrons() {
  let schematrons = cts.uris(null, null, cts.directoryQuery('/schematron/', 'infinity'));
  return schematrons;
}

