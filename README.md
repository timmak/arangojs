# API

All asynchronous functions take node-style callback functions with the following arguments:

* *err*: an *Error* object if an error occurred, or *null* if no error occurred.
* *result*: the function's result (if no error occurred).

If the server-side ArangoDB API returned an error, *err* will be an instance of *ArangoError*.

## Database API

### new Database([config])

Creates a new *database*.

*Parameter*
* *config* (optional): an object with the following properties:
 * *url* (optional): base URL of the ArangoDB server. Default: `http://localhost:8529`.
 * *databaseName* (optional): name of the active database. Default: `_system`.
 * *arangoVersion* (optional): value of the `x-arango-version` header. Default: `20200`.
 * *headers* (optional): an object with headers to send with every request.

If *config* is a string, it will be interpreted as *config.url*.

### Manipulating collections

#### database.createCollection(properties, callback)

Creates a collection from the given *properties*, then passes a new *Collection* to the callback.

#### database.collection(collectionName, [autoCreate,] callback)

Fetches the collection with the given *collectionName* from the database, then passes a new *Collection* to the callback.

If *autoCreate* is set to `true`, a collection with the given name will be created if it doesn't already exist.

#### database.collections([excludeSystem,] callback)

Fetches all collections from the database and passes an array of new *Collection* instances to the callback.

If *excludeSystem* is set to `true`, system collections will not be included in the result.

#### database.dropCollection(collectionName, callback)

Removes the collection with the given *collectionName* from the database.

#### database.truncate([excludeSystem,] callback)

Deletes **all documents** in **all collections** in the active database.

If *excludeSystem* is set to `true`, system collections will not be truncated.

### Manipulating graphs

#### database.createGraph(properties, callback)

#### database.graph(graphName, [autoCreate,], callback)

#### database.graphs(callback)

#### database.dropGraph(graphName, [dropCollections,] callback)

### Manipulating databases

#### database.createDatabase(databaseName, callback)

#### database.database(databaseName, [autoCreate,] callback)

#### database.databases(callback)

#### database.dropDatabase(databaseName, callback)

### Queries

#### database.query(query, [bindVars,] callback)

Performs a database query using the given *query* and *bindVars*.

*Parameter*

* *query*: an AQL query string or a [query builder](https://npmjs.org/package/aqb) instance.
* *bindVars* (optional): an object with the variables to bind the query to.

The callback will receive a *Cursor* instance.

## Cursor API

### cursor.all(callback)

Depletes the cursor and passes an array containing all values returned by the query.

### cursor.next(callback)

Advances the cursor and passes the next value returned by the query. If the cursor has already been depleted, passes `undefined` instead.

### cursor.hasNext():Boolean

Returns `true` if the cursor has more values or `false` if the cursor has been depleted.

### cursor.each(fn, callback)

Depletes the cursor by applying the function *fn* to each value returned by the query, then invokes the callback with no result value.

Equivalent to *Array.prototype.forEach*.

### cursor.every(fn, callback)

Advances the cursor by applying the function *fn* to each value returned by the query until the cursor is depleted or *fn* returns a value that evaluates to `false`.

Passes the return value of the last call to *fn* to the callback.

Equivalent to *Array.prototype.every*.

### cursor.some(fn, callback)

Advances the cursor by applying the function *fn* to each value returned by the query until the cursor is depleted or *fn* returns a value that evaluates to `true`.

Passes the return value of the last call to *fn* to the callback.

Equivalent to *Array.prototype.some*.

### cursor.map(fn, callback)

Depletes the cursor by applying the function *fn* to each value returned by the query, then invokes the callback with an array of the return values.

Equivalent to *Array.prototype.map*.

### cursor.reduce(fn, [accu,] callback)

Depletes the cursor by reducing the values returned by the query with the given function *fn*. If *accu* is not provided, the first value returned by the query will be used instead (the function will not be invoked for that value).

Equivalent to *Array.prototype.reduce*.

## Collection API

### Getting information about the collection

See [the HTTP API documentation](https://docs.arangodb.com/HttpCollection/Getting.html) for details.

#### collection.properties(callback)

Retrieves the collection's properties.

#### collection.count(callback)

Retrieves the number of documents in a collection.

#### collection.figures(callback)

Retrieves statistics for a collection.

#### collection.revision(callback)

Retrieves the collection revision ID.

#### collection.checksum([opts,] callback)

Retrieves the collection checksum.

### Manipulating the collection

#### collection.load([count,] callback)

Tells the server to load the collection into memory.

If *count* is set to `false`, the return value will not include the number of documents in the collection (which may speed up the process).

#### collection.unload(callback)

Tells the server to remove the collection from memory.

#### collection.setProperties(properties, callback)

Replaces the properties of the collection.

#### collection.rename(name, callback)

Renames the collection. The *Collection* instance will automatically update its name according to the server response.

#### collection.rotate(callback)

Rotates the journal of the collection.

#### collection.truncate(callback)

Deletes **all documents** in the collection in the database.

#### collection.drop(callback)

Deletes the collection from the database.

### Manipulating documents

#### collection.replace(documentHandle, data, [opts,] callback)

Replaces the content of the document with the given *documentHandle* with the given *data*.

The *documentHandle* can be either the *_id* or the *_key* of a document in the collection.

#### collection.update(documentHandle, data, [opts,] callback)

Updates (merges) the content of the document with the given *documentHandle* with the given *data*.

The *documentHandle* can be either the *_id* or the *_key* of a document in the collection.

#### collection.remove(documentHandle, [opts,] callback)

Removes the document with the given *documentHandle* from the collection.

The *documentHandle* can be either the *_id* or the *_key* of a document in the collection.

#### collection.all([type,] callback)

Retrieves a list of all documents in the collection.

If *type* is set to `"key"`, the result will be the `_key` of each document.

If *type* is set to `"path"`, the result will be the document URI paths.

If *type* is set to `"id"` or not set, the result will be the `_id` of each document.

### DocumentCollection API

Document collections extend the *Collection* API with the following methods.

#### documentCollection.document(documentHandle, callback)

Retrieves the document with the given `documentHandle` from the collection.

The *documentHandle* can be either the *_id* or the *_key* of a document in the collection.

#### documentCollection.save(data, [opts,] callback)

### EdgeCollection API

Edge collections extend the *Collection* API with the following methods.

#### edgeCollection.edge(documentHandle, callback)

Retrieves the edge with the given `documentHandle` from the collection.

The *documentHandle* can be either the *_id* or the *_key* of an edge in the collection.

#### edgeCollection.save(data, fromId, toId, [opts,] callback)

#### edgeCollection.edges(vertex, [opts,] callback)

#### edgeCollection.inEdges(vertex, [opts,] callback)

#### edgeCollection.outEdges(vertex, [opts,] callback)

## Graph API

### graph.drop([dropCollections,] callback)

### Manipulating vertices

#### graph.vertexCollection(collectionName, callback)

#### graph.addVertexCollection(collectionName, callback)

#### graph.removeVertexCollection(collectionName, [dropCollection,] callback)

### Manipulating edges

#### graph.edgeCollection(collectionName, callback)

#### graph.addEdgeDefinition(definition, callback)

#### graph.replaceEdgeDefinition(definitionName, definition, callback)

#### graph.removeEdgeDefinition(definitionName, [dropCollection,] callback)

### VertexCollection API

Graph vertex collections extend the *Collection* API with the following methods.

#### vertexCollection.vertex(documentHandle, callback)

Retrieves the vertex with the given `documentHandle` from the collection.

The *documentHandle* can be either the *_id* or the *_key* of a vertex in the collection.

#### vertexCollection.save(data, [opts,] callback)

### EdgeCollection API

Graph edge collections extend the *Collection* API with the following methods.

#### edgeCollection.edge(documentHandle, callback)

Retrieves the edge with the given `documentHandle` from the collection.

The *documentHandle* can be either the *_id* or the *_key* of an edge in the collection.

#### edgeCollection.save(data, fromId, toId, [opts,] callback)