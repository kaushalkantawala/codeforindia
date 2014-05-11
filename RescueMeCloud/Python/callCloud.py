import json,httplib
connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()
'''connection.request('POST', '/1/functions/updateLocation', json.dumps({
            "deviceid" : "E314103E-62CD-4168-91D6-0781D1D87B58",
            "latitude" : -74,
            "longitude" : 50,
     }), {
       "X-Parse-Application-Id": "ffpXx4E4hBuTvY05bCs6Pc6F0myJKHM19tJ82b0s",
       "X-Parse-REST-API-Key": "GXuLJRjsGP4ueoDc32Bz2qOUYrYb1qTQmcppBufz",
       "Content-Type": "application/json"
     })'''
     
'''connection.request('POST', '/1/functions/pushNotification', json.dumps({
            "deviceid" : "DDFFGG",
            "latitude" : -81,
            "longitude" : 57,
            "miles" : 5
     }), {
       "X-Parse-Application-Id": "ffpXx4E4hBuTvY05bCs6Pc6F0myJKHM19tJ82b0s",
       "X-Parse-REST-API-Key": "GXuLJRjsGP4ueoDc32Bz2qOUYrYb1qTQmcppBufz",
       "Content-Type": "application/json"
     })'''

connection.request('POST', '/1/functions/push', json.dumps({
            "deviceId" : "DDFFGG",
            "distressId" : "AABBCC",
            "latitude" : -81,
            "longitude" : 57,
            "miles" : 5
     }), {
       "X-Parse-Application-Id": "ffpXx4E4hBuTvY05bCs6Pc6F0myJKHM19tJ82b0s",
       "X-Parse-REST-API-Key": "GXuLJRjsGP4ueoDc32Bz2qOUYrYb1qTQmcppBufz",
       "Content-Type": "application/json"
     })  

result = json.loads(connection.getresponse().read())

print result