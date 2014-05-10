
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("createUser",function(request,response) {
	var userentry = Parse.Object.extend("User");
	var user = new userentry();
	user.set("firstName","Ron");
	user.set("lastName","Jack");
	
	
	user.save(null,{
		success: function(user) {
    // Execute any logic that should take place after the object is saved.
    		//alert('New object created with objectId: ' + user.id);
    		response.success('New object created with objectId: ' + user.id);
  		},
		error: function(user, error) {
    // Execute any logic that should take place if the save fails.
    // error is a Parse.Error with an error code and description.
    //alert('Failed to create new object, with error code: ' + error.description);
    response.success('Failed to create new object, with the error code: ' + error);
 	 }
	}); 
	//user.save();
});

Parse.Cloud.define("retreiveUser",function(request,response){
	
	var userObj = Parse.Object.extend("RescueMeTestObject");
	
	var query = new Parse.Query(userObj);
	
	query.get("uS3fGJzIQo",{
		
		success : function(user) {
			response.success(user);
			
		},
		error : function (object,error) {
			
		}
	});
});

Parse.Cloud.define("updateLocation",function(request,response){
	
	var query = new Parse.Query("Location");
	var deviceid= request.params.deviceid;
	query.equalTo("deviceId",deviceid);
	console.log("Updating location for device : "+deviceid);
	query.find({
		
		success : function(row) {
			var objid = row[0].id;			
			console.log("Trying to update object id : "+objid);
			query.get(objid,{
						success : function(row2){
								row2.set("latitude",request.params.latitude);
								console.log("latitude received : "+request.params.latitude);
								row2.set("longitude",request.params.longitude);
								console.log("longitude received : "+request.params.longitude);
								row2.save(null,{
										success:function(row2){
											console.log(row2+ " : updated successfully");
											response.success( row2+ " : updated successfully");
										},
										error:function(row2,error){
											console.log(" Failed to update : "+row2 +" because of error "+error);
											response.error(" Failed to update : "+row2 +" because of error "+error);
				
										}
									});
						},
							error : function(row2,error){
									console.log("Failed to get db row for "+ row2 + " because of error "+error);
									response.error("Failed to get db row for "+ row2 + " because of error "+error);				
							}		
			
					});
			
				},
				error : function (object,error) {
				console.log(" Failed to get anything because of "+error);
				response.error(" Failed to get anything because of "+error);
			}
		});		
});


Parse.Cloud.define("pushNotification",function(request,response){
	
	var recipients =[];
	var query2;
	console.log(typeof recipients);
	var query = new Parse.Query("EmergencyContacts");
	query.equalTo("deviceId",request.params.deviceid);
	query.find({
		success : function(contacts){
			//response.success("For deviceid "+ request.params.deviceid+" found contacts : "+contacts.length);
						for(var i =0;i<contacts.length;i++){
									var phonenum = contacts[i].get("phoneNumber");
									console.log("Searching for phone num : "+phonenum);
									query2 = new Parse.Query("UserObject");
									query2.equalTo("Phone",phonenum);
									query2.find({
												success : function(user){
													console.log("phone : "+phonenum+" user size : "+user.length+" user : "+user);
													recipients.push(user[0].get("DeviceId"));
													console.log("Device : "+user[0].get("DeviceId")+" added to recipients");
												},
												error : function(error){
													console.log("Could not get Deviceid of "+phonenum);
													//response.log("Could not get Deviceid of "+phonenum);	
												}
										
									});
						}
		},
		error : function(contacts){
			response.error("Failed to get contacts for device :"+deviceId+" because : "+error);
		}
		
	});
	
	console.log(" All Recipients : "+recipients);

});
