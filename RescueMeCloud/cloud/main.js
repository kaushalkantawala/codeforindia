
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
	var lat = request.params.latitude;
	var longi = request.params.longitude;
	var geopoint = request.params.geopoint;
	if(geopoint == null){
		console.log("Geopoint not received in request");
		geopoint=new Parse.GeoPoint(lat,longi);
	}
	console.log("Geopoint : "+geopoint);
	query.equalTo("deviceId",deviceid);
	console.log("Updating location for device : "+deviceid);
	query.find({
		
		success : function(row) {
			var objid = row[0].id;			
			console.log("Trying to update object id : "+objid);
			query.get(objid,{
						success : function(row2){
								row2.set("latitude",lat);
								console.log("latitude received : "+lat);
								row2.set("longitude",longi);
								console.log("longitude received : "+longi);
								row2.set("geopoint",geopoint);
								console.log("geopoint created: "+geopoint);
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
	
	console.log("Inside pushNotification");
	var phonenum=[],recipients =[],channels=[];
	var query2,geoquery;
	var victim_name="";
	var deviceId = request.params.deviceid;
	var distress = request.params.distressId;
	var radius_query = new Parse.Query("Location");
	//var lat = request.params.latitude;
	//var longi = request.params.longitude;
	//var miles = request.params.miles;
	var lat,longi,miles;
	//var geopoint = new Parse.GeoPoint(lat,longi);
	var dist_query = new Parse.Query("distress");
	dist_query.equalTo("distressId",distress);
	dist_query.find({
		success: function(incident){
			lat = incident[0].get("latitude");
			longi = incident[0].get("longitude");
			miles = incident[0].get("miles");
			console.log("lat : "+lat+" longi : "+longi+" miles : "+miles);
		},
		error : function(){
			console.log("Did not find incident with id : "+distress);
			response.error("Did not find incident with id : "+distress);
		}
	});
	var min_lat = lat - miles;
	var max_lat = lat + miles;
	var min_longi = longi - miles;
	var max_longi = longi + miles;
		
	var contact_query = new Parse.Query("EmergencyContacts");
	var name_query = new Parse.Query("UserObject");
	name_query.equalTo("DeviceId",deviceId);
	name_query.find({
		success : function(victim){
			victim_name = victim[0].get("FirstName") + " " +victim[0].get("LastName");
			console.log("Victim's name : "+victim_name);
		},
		error :function(){
			
		}
	});
	contact_query.equalTo("deviceId",deviceId);
	contact_query.find({
		success : function(contacts){
			//response.success("For deviceid "+ request.params.deviceid+" found contacts : "+contacts.length);
						for(var i =0;i<contacts.length;i++){
									phonenum.push( contacts[i].get("phoneNumber"));
						}
									console.log("Searching for phone num : "+phonenum);
									query2 = new Parse.Query("UserObject");
									query2.containedIn("Phone",phonenum);
									query2.find({
												success : function(user){
													console.log("phone : "+phonenum+" user size : "+user.length+" user : "+user);
													for(var x =0;x<user.length;x++){
														recipients.push(user[x].get("DeviceId"));
													}
													console.log("Device : "+recipients+" added to recipients");
													//console.log("Typeof reci : "+ typeof recipients);
													//response.success("recipients : "+ recipients);
													
													radius_query.lessThanOrEqualTo("latitude",max_lat);
													radius_query.greaterThanOrEqualTo("latitude",min_lat);
													radius_query.lessThanOrEqualTo("longitude",max_longi);
													radius_query.greaterThanOrEqualTo("longitude",min_longi);
													//radius_query.withinMiles("geopoint",geopoint,miles);
													radius_query.find({
														success : function(nearby_vol){
															for(var y=0;y<nearby_vol.length;y++){
																console.log("Nearby Device : "+nearby_vol[y].get("deviceId")+" added to recipients");
																recipients.push(nearby_vol[y].get("deviceId"));
															}
															console.log("Sending push notifications to recipients : "+ recipients);
															//response.success("recipients : "+ recipients);
														},
														error : function(){
															console.log("Could not find any user in proximity");
															response.error("Could not find any user in proximity");
														}
														
													});
													
													Parse.Push.send({
											         //console.log("Sending push notifications to recipients : "+ recipients);
													
														channels : recipients,
														//channels:[],
														data : {
																alert : victim_name,
     															badge: "Increment",
     															sound: "cheering.caf",
     															title: distress
   
																}
														},{
															success : function(){
															console.log("Push notification successful to recipients: "+ recipients);
															},
															error : function(error){
															console.log("Push notification unsuccessful to recipients: "+ recipients +" : "+error);
															}
													});	
												},
												error : function(error){
													console.log("Could not get Deviceid of "+phonenum);
													//response.log("Could not get Deviceid of "+phonenum);	
												}
										
									});
								
						
						
		},
		error : function(contacts){
			response.error("Failed to get contacts for device :"+deviceId+" because : "+error);
		}		
	});
	
	

});


Parse.Cloud.define("acknowledge",function(){
	
	var deviceId = request.params.deviceId;
	var distressId = request.params.distressId;
	var distress_query = new Parse.Query("distress");
	distress_query.equalTo("distressId",distressId);
		
	distress_query.find({
			success : function(incident){
				var objid = incident[0].id;
				distress_query.get(objid,{
								success : function(incident2){
											incident2.set("ack",deviceId);
											console.log("Incident : "+distressId+" acked by devide : "+deviceId);
											incident2.save(null,{
														success : function(){
															console.log("Incident : "+distressId +" acked / updated");
														},
														error : function(error){
															console.log("Incident : "+distressId +" could not be acked updated because : "+error);
														}
											});
								},
								error : function(objid){
									console.log("Did not find any incident by id : "+objid);
								}
					});
				
				
				
			},
			error : function(distressId,error){
				console.log("Did not find any incident by id : "+distressId+" because : "+error);
				response.error("Did not find any incident by id : "+distressId+" because: "+error);
			}
	});
	
});


Parse.Cloud.define("push",function(request,response){
	var deviceid = request.params.deviceId;
	var distressId = request.params.distressId;
	//var distress_query = new Parse.Query("distress");
	//distress_query.equalTo("deviceId",deviceId);
	//distress_query.notEqualTo("ack",[""]);
	//distress_query.descending("createdAt");
	//distress_query.limit(1);
	/*distress_query.find({
				success : function(distress){
					distressId = distress[0].id;
					console.log("Distress Id to work on : "+distressId);
				},
				error :function(){
					response.error("Found no distresses reported by device : "+ deviceId);
				}
	});*/
	
	var data = {
				distressId : distressId,
				deviceid:deviceid
				
	};
	Parse.Cloud.run("pushNotification",{ deviceid : deviceid,distressId :distressId });
	//Parse.Cloud.run("pushNotification",data);
	/*Parse.Push.send({
											//console.log("Sending push notifications to recipients : "+ recipients);
											channels : ["F67940D0-C4DC-4E2D-862F-E5FCB94BC609"],
											data : {
												alert : "I neddd helpppp"
											}
										},{
											success : function(channels){
												console.log("Push notification successful to recipients: "+ channels);
											},
											error : function(channels,error){
												console.log("Push notification unsuccessful to recipients: "+ channels +" : "+error);
											}
									});	
									*/
});