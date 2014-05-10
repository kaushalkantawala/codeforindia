import json,httplib
connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()
'''connection.request('POST', '/1/functions/updateLocation', json.dumps({
            "deviceid" : "BD493D08-A53A-4540-9F03-5D81E08E1F4E",
            "latitude" : 9090909,
            "longitude" : 67676767
     }), {
       "X-Parse-Application-Id": "ffpXx4E4hBuTvY05bCs6Pc6F0myJKHM19tJ82b0s",
       "X-Parse-REST-API-Key": "GXuLJRjsGP4ueoDc32Bz2qOUYrYb1qTQmcppBufz",
       "Content-Type": "application/json"
     })'''
     
connection.request('POST', '/1/functions/pushNotification', json.dumps({
            "deviceid" : "DDFFGG",
            "latitude" : 9090909,
            "longitude" : 67676767
     }), {
       "X-Parse-Application-Id": "ffpXx4E4hBuTvY05bCs6Pc6F0myJKHM19tJ82b0s",
       "X-Parse-REST-API-Key": "GXuLJRjsGP4ueoDc32Bz2qOUYrYb1qTQmcppBufz",
       "Content-Type": "application/json"
     })
result = json.loads(connection.getresponse().read())

print result