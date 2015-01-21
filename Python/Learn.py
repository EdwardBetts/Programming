import json,httplib
connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()
connection.request('POST', '/1/functions/cleanPanics', json.dumps({}), {
       "X-Parse-Application-Id": "cBZmGCzXfaQAyxqnTh6eF2kIqCUnSm1ET8wYL5O7",
       "X-Parse-REST-API-Key": "NZMM2wASEYLIoG49Su42S9UbH4dSQGVgQd6ijdV3",
       "Content-Type": "application/json"
     })
result = json.loads(connection.getresponse().read())
print result