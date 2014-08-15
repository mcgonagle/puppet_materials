var root = "http://www.manhunt.net/multichat/"; 
var loginPageURL = root + "getUserInfo";
var roomListURL = root + "ajaxGetServerRoomList"
var maxConnsURL = root + "getChatSettings";
var verifyCaptchaURL = root + "verifyCaptcha"; 
var populationLimit = 20; 
var roomResizeThreshold = 85; 
var randomListLength = 30; 
var captchaCheck = false; 
var randomCache; 
var loginQueue = []; 
var loggedInQueue = []; 
var silenceArray = [];
var upkeepInterval; 
var pingInterval;
var imageCache = false; 
var roomLL = new Array(); 

var newRoomObj = { pwd: "", maxU: 250, isGame: false, isLimbo: false, uCount: true }; 
const responseFormat = "xml";

function init()
{
        // Using trace will send data to the server console
        trace("Man Chat Go!")
		//loadSettings();
		//setupStuff(); 
		upkeepInterval = setInterval("doUpkeep", 20000, { } );  
		pingInterval = setInterval("doPing", 180000, { } ); 
		//createUserListCache(); 
		getRoomList(); 
}
function getRoomList() { 
	var serverIn = new LoadVars(), serverOut = new LoadVars();
	serverOut.sendAndLoad(roomListURL, serverIn, "post")
	serverIn.onLoad = parseRoomList; 
}
function parseRoomList() { 
	var rl = this.roomList; 
	//trace("ABOUT TO SPLIT: " + rl); 
	var roomArr = rl.split('|');
	var l = roomArr.length; 
	for (var i = 0; i < l; i++) { 
		
		var keyNamePair = roomArr[i];
		if (!keyNamePair) continue; 
		var commaPos = keyNamePair.indexOf(","); 
		if (commaPos == -1) continue; 
		makeNewRoom(keyNamePair.substr(0, commaPos), keyNamePair.substring(commaPos + 1, keyNamePair.length)); 
	}
	loadSettings(); 
	setupStuff(); 
	createUserListCache(); 
}
function doPing() { 
	var z = _server.getCurrentZone();
	var r = z.getRoomByName("ControlRoom");
	var us = r.getAllUsers();
	//var usl = us.length;
	_server.sendResponse( { _cmd: "p" },  -1, null, us); 
}
function loadSettings() {
	var serverIn = new LoadVars(), serverOut = new LoadVars();
	serverOut.sendAndLoad(maxConnsURL, serverIn, "post")	
	serverIn.onLoad = settingsLoaded; 
	
}
function settingsLoaded() { 
	populationLimit = Number(this.chat_max_users); 
	captchaCheck = (Number(this.chat_captcha) > 0); 
}
function destroy()
{
	clearInterval(pingInterval); 
	clearInterval(upkeepInterval); 
	var z = _server.getcurrentZone();
	var rs = z.getRooms();
	for (var i = 0; i < rs.length; i++) { 
		_server.destroyRoom(z, rs[i].getId()); 
	}
    trace("Bye bye!")
}
function setupStuff() { 
	
	var z = _server.getCurrentZone(); 
	var zr = z.getRooms();	
	var zrl = zr.length; 
	for (var i = 0; i < zrl; i++) { 
		if (zr[i].isLimbo()) continue; 
		roomLL.push(new Array(zr[i])); 		
	}
	
}
function handleRequest(cmd, params, user, fromRoom)
{
		if (cmd == "rul") { // Random User List 

			var response = new Object(); 
			var responseArray = randomCache; 
			response.ct = responseArray.length; 
			response._cmd = "rul"; // Get Room User List By Id 
			//response.r_id = params.roomId;
			response.values = responseArray; 
			
			_server.sendResponse(response, -1, null, [user], responseFormat); 
				return;
		}
		else if (cmd == "rj")  {  // Room Join Request

			var rid = params.rid;
			if (captchaCheck) { 
				if (user.properties.get('captchad') == false) {
					_server.sendResponse( { _cmd: "captcha", rid: rid }, -1, null, [user], responseFormat);
					return; 
				}
			}			
			var zone = _server.getCurrentZone();
			var room = zone.getRoom(rid); 
			if (room == null) { 
				// No room exists anymore
				_server.sendResponse( { _cmd: "rjx" }, rid, null, [user], responseFormat);
				return;
			}
			if (room.getUserCount() >= user.getVariable("ent_chat_occupancy").getValue()) {
				// Room is full
				_server.sendResponse( { _cmd: "rjf"}, rid, null, [user], responseFormat); 
				return;
			}
			if (user.getRoomsConnected() > user.getVariable("ent_chat_join_rooms").getValue()) { 
				// User is joined too many rooms... hacker?
				_server.sendResponse( { _cmd: "rjr" }, rid, null, [user], responseFormat); 
				return;
			}
			// Everything is okay!  
			_server.sendResponse( { _cmd: "rjok", rid: rid }, rid, null, [user], responseFormat); 
			return; 
			
		}		
        else if (cmd == "getRoomUserListById")
        {
			var zone = _server.getCurrentZone(); 
			var room = zone.getRoom(params.roomId); 
			if (room == null) { 
				_server.sendResponse( { _cmd: "noroom" }, params.roomId, null, [user], responseFormat); 
				return; 
			}
			var userList = room.getAllUsers();
			var l = userList.length;
		
			var response = new Object(); 
			
			var responseArray = room.properties.get("userListCache"); 
			response.ct = room.getUserCount(); //responseArray.length; 
			response._cmd = "grulbi"; // Get Room User List By Id 
			response.r_id = params.roomId;
			response.values = responseArray; 
			
			_server.sendResponse(response, params.roomId, null, [user], responseFormat); 
				return;
        }
		else if (cmd == "grlbk") { // Get Room List By Key
			var zone = _server.getCurrentZone();
			var roomList = zone.getRooms(); 			
			var l = roomList.length;
			var response = new Object;
			response._cmd = "grlbk" 
			var sendRoomList =  new Object(); 
			for (var i = 0; i < l; i++) { 
				var rm = roomList[i];
				var rmkey = rm.getVariable('room_key');
				if (rmkey == null) continue;
				rmkey = rmkey.getValue(); 
				if (sendRoomList[rmkey] == undefined) sendRoomList[rmkey] = new Array(); 
					sendRoomList[rmkey].push( { n: rm.getName(), id: rm.getId(), c: rm.getUserCount() } );  // Name, id, count
			}
			response.rl = sendRoomList; 
			_server.sendResponse(response, -1, null, [user], responseFormat); 
		}
		else if (cmd == "uu") { 
			//cmd, params, user, fromRoom
			//var rm = _server. 	
			var z = _server.getCurrentZone(); 
			var r_id = fromRoom; //params.r_id;
			var r = z.getRoom(params.roomId); 			
			var allUsers = r.getAllUsers();
			var logt = new Date().valueOf(); 
			_server.sendResponse( { _cmd: 'uu', logt: logt, r_id: r_id, u_id: user.getUserId() },r.getId(), user, allUsers, "xml");   // User update
			var l = allUsers.length; 
			var loginList = new Object(); 
			for (var i = 0; i < l; i++) { 
				var logt = allUsers[i].properties.get('join_time');
				if (!logt) continue; 
				loginList[allUsers[i].getUserId()] = allUsers[i].properties.get('join_time');
			}
			_server.sendResponse( { _cmd: 'ul', loginList: loginList, r_id: r_id},  r_id, null, [user], "xml");
		}
		else if (cmd == "rf") { // refresh user data 
			// Uid or Memcache key
			//var u = user; 
			var serverIn = new LoadVars(), serverOut = new LoadVars();			
			serverOut.uid = Number(user.getVariable('mh_id').getValue()); //params.mh_id; 			
			serverOut.refresh = "Reqa!?tr!gedeFr#hA@wache=esU6e=AC+7P&chevu*8ped=uCHE4Ena3AsTa=5"; 
			serverIn.onLoad = handleGetDataRequest; 
            serverOut.sendAndLoad(loginPageURL, serverIn, "post");			
			serverIn.requestData = { nick: user.getName(), pass: Number(serverOut.uid), user: user, loginRequest: false };
		}
		else if (cmd == "silence") { 
			if (!user.properties.get("isAdmin")) { return; }// This is where we test and maek sure the user issuing the command is an admin user  
			var target_mhid =  params.mhid;
			var target_name = params.username; 
			var u = findUserInControlRoom(target_mhid, target_name); 
			if (!u) { return; } // User must have logged out of the server in the interim
			addToSilenceArray(target_mhid, u.getUserId(), params.duration*1000); 			
			_server.sendResponse ( { _cmd: 'silence', additional: params.additional }, -1, null, [u], "json"); 
		}
		else if (cmd == "warn") { 
				if (!user.properties.get("isAdmin")) { return; }// This is where we test and maek sure the user issuing the command is an admin user  
			var target_mhid =  params.mhid;
			//var r_id = fromRoom; // The room the command was issued from... should be the control room
			var target_name = params.username; 
			var u = findUserInControlRoom(target_mhid, target_name); 
			if (!u) { return; } // User must have logged out of the server in the interim
			_server.sendResponse( { _cmd: 'warn', additional: params.additional}, -1, null, [u], "json");
			
		}
		else if (cmd == "ban") { 
			if (!user.properties.get("isAdmin")) { return; }// This is where we test and maek sure the user issuing the command is an admin user  
			var target_mhid =  params.mhid;
			//var r_id = fromRoom; // The room the command was issued from... should be the control room
			var target_name = params.username; 
			var u = findUserInControlRoom(target_mhid, target_name); 
			if (!u) { return; } // User must have logged out of the server in the interim
			_server.kickUser(u, 5, "You are being kicked."); 
			_server.sendResponse ({ _cmd: 'ban', additional: params.additional}, -1, null, [u], "json");
			
		} else if (cmd == "bc") { 
			trace("Doing broadcast: " + params.msg); 
			
			if (!user.properties.get("isAdmin")) { return; }
			var z = _server.getCurrentZone();
			var r = z.getRoomByName("ControlRoom");
			var us = r.getAllUsers(); 
			_server.sendResponse({_cmd: 'bc', msg: params.msg}, -1, null, us, "json"); 
		}else if (cmd == "lmc") { 
			if (!user.properties.get("isAdmin")) { return; }// This is where we test and maek sure the user issuing the command is an admin user  			
			loadSettings();  
			return; 		
		} else if (cmd == "captchaOK") { 
			var serverIn = new LoadVars(), serverOut = new LoadVars();			
			serverOut.uid = Number(user.getVariable('mh_id').getValue()); //params.mh_id; 			
			serverIn.onLoad = captchaOKLoaded; 
            serverOut.sendAndLoad(verifyCaptchaURL, serverIn, "post");			
			serverIn.u = user;
			serverIn.rid = params.rid; 
			return;
		} else if (cmd == "w") {
			var sfid = params.uid; 
			//var senderId = user.getUserId();
			var recipient = _server.getUserById(params.sfid); 
			if (!recipient) return; 
			_server.sendResponse( { _cmd: "w", mhid: user.getVariable('mh_id').getValue(), m: params.m}, -1, user, [recipient]); 
			
			
		}
}
function captchaOKLoaded() { 	
	if (this.ok) { 
		
		this.u.properties.put("captchad", true); 
		handleRequest("rj", { rid: this.rid }, this.u, -1); 
		return;
	} else { 
		// this should never happen, and if it does, someone's tryin' to hack us. 
	}
}
function createUserListCache() { 
	var z = _server.getCurrentZone(); 
	var rs = z.getRooms(); 
	var rsl = rs.length; 
	
	for (var i = 0; i < rsl; i++) { 
		if (rs[i].getName() == "ControlRoom") continue;
		var newCache = makeSummaryFromUserList(rs[i].getAllUsers()); 
		rs[i].properties.put('userListCache', newCache);
	}
	var cr = z.getRoomByName("ControlRoom");
	var crul = cr.getAllUsers(); // Control Room User List 
	var crull = crul.length; 
	var crArr = new Array(); 
	for (var i = 0; i < randomListLength && crull > 0; i++) { 
		var u = crul.splice(Math.floor(Math.random() * crull), 1)[0];
		crull--; 
		if (!u) continue; 
		crArr.push(u); 
	}
	randomCache = makeSummaryFromUserList(crArr); 
	
}
function makeSummaryFromUserList(userArr) { 
	var responseArray = new Array(); 
	var l = userArr.length;
	for (var i  = 0; i < l; i++) { 
				//var j = Math.floor(Math.random() * l--);
				var u = userArr[i];
				if (!u) continue; 
				if (u.properties.get("isAdmin")) continue; 
				responseArray.push( 
					{ sn: u.getName(), 
					  sf_id: u.getUserId(), 
					  loc: u.getVariable('loc').getValue(),
					  mh_id: u.getVariable('mh_id').getValue(),
					  psn: u.getVariable('psn').getValue(), 
					  age:u.getVariable('age').getValue(),
					  buid: u.getVariable('buid').getValue(),
					  logt: u.properties.get('join_time')
					} );
				
	}
	return responseArray;
}
function findUserInControlRoom(mhid, username) { 
			var z = _server.getCurrentZone(); 
			var r = z.getRoomByName("ControlRoom"); 
			if (!r.contains(username)) { return false; } // This means that the user isn't logged in to this server.
			var allUsersOnServer = r.getAllUsers(); 
			var l = allUsersOnServer.length; 
			var u; 
			for (var i = 0; i < l; i++) { 
				if (allUsersOnServer[i].getVariable('mh_id').getValue() == mhid) {
					u = allUsersOnServer[i];
					break;
				}
			}
			if (!u) {  return false;  } 
			return u;
}
function addToSilenceArray(mhid, uid, duration) { 
	var l = silenceArray.length;
	var r; 
	for (var i = 0; i < l; i++) { 
		if (silenceArray[i].mhid == mhid) {
			r = silenceArray[i];
			break;
		}
	}
	if (r) { // This user already exists in the silence Array
		u.endTime = (duration) + new Date().valueOf(); 
		u.uid = uid; 
	} else { 
		silenceArray.push( { mhid: mhid, uid: uid, endTime: (duration)+ new Date().valueOf() } ); 
		var u = _server.getUserById(uid); 
		_server.setUserVariables(u, {silence: true} ); 		
	}
}
function removeFromSilenceArray(uid) { 
var l = silenceArray.length;
	for (var i = 0; i < l; i++) { 
		if (silenceArray[i].uid == uid) {
			silenceArray.splice(i--, 1);
			break;
		}
	}
}
function doUpkeep() {  	
	roomSizeInterval();
	silenceInterval();
	createUserListCache(); 
	
}
function roomSizeInterval() { 
	//		roomLL[zr[i].getName()] = new Array(zr[i]); 		
	for (var key = 0; key < roomLL.length; key++) { 
		l = roomLL[key].length;
		i = l - 1; 
		if (roomLL[key][i].getUserCount() >= roomResizeThreshold) {
			makeOverfillRoom(key, roomLL[key][0].getName() + " " + (roomLL[key].length+1)); 
		} else if (i > 0 && roomLL[key][i].getUserCount() == 0 && roomLL[key][i-1].getUserCount() < roomResizeThreshold) { 
			deleteRoom(key, roomLL[key][i].getId()); 
		}
	}
}
function makeOverfillRoom(key, name) { 
	var z = _server.getCurrentZone();
	var keyVal = Number(roomLL[key][0].getVariable('room_key').getValue());
	newRoomObj['name'] = name;
	var roomVars = new Array({ name:"room_key", val: keyVal, priv: true, persistent: true } );
	var rm = _server.createRoom(newRoomObj, null, true, true, roomVars); 
	roomLL[key].push(rm); 
	
}
function makeNewRoom(roomKey, name) { 
	var z = _server.getCurrentZone();
	//var i = roomLL.push(new Array()) - 1; //[0].getVariable('room_key').getValue());
	newRoomObj['name'] = name;
	var roomVars = new Array({ name:"room_key", val: roomKey, priv: true, persistent: true } );
	var rm = _server.createRoom(newRoomObj, null, true, true, roomVars); 
	//var LL = roomLL[i].push(rm); 	
	//trace("new Room [" + i + "] " + LL + ", cos: " + name); 
}
function deleteRoom(key,rmId) { 
	var success = _server.destroyRoom(_server.getCurrentZone(), rmId); 
	if (success) { 
		roomLL[key].splice(roomLL[key].length-1, 1); 
	}
}
function silenceInterval() { 
	var l = silenceArray.length;
	var now = new Date().valueOf();
	for (var i = 0; i < l; i++) {
		if (silenceArray[i].endTime < now) { 
			var sa = silenceArray.splice(i, 1)[0]; 
			i--;
			l--; 			
			var u = _server.getUserById(sa.uid); 
			if (!u) return;
			_server.setUserVariables(u, {silence: undefined } ); 
			_server.sendResponse( { _cmd: "unsilenced" }, -1, null, [u], responseFormat); 
			//u.setUserVariables("silenced", false); 
		}
	}
}

function handleInternalEvent(evtObj)
{
        // Simply print the name of the event that was received
		if (evtObj.name == "loginRequest") { 

			var nick = evtObj.nick;	// User Name ... Insecure, but we will confirm this on the UID check
			var adminNick = nick.substr(0, 7); 
			if (adminNick == "##ADMIN" && evtObj.pass == "pREprekEwe__bRujece-RA&as#ubrAthugasu_up6+GuqAdr+t+ExaYuthuwR3ph") {
				var obj = _server.loginUser(evtObj.nick , '', evtObj.chan, true); 
					if (!obj.success) { 
						_server.sendResponse( { _cmd: "logKO", txt: "Already Logged In"}, -1, null, evtObj.chan, responseFormat);
						return;  
					}
					var u = _server.getUserByChannel(evtObj.chan);
					_server.setUserVariables(u, { mh_id: -1 }, false);
					u.properties.put("isAdmin", true); 
					_server.sendResponse( { _cmd: "logOK", uid: u.getUserId() }, -1, null, evtObj.chan, responseFormat);			return;	
				/* end debug */
			}
			/* pop limit! */
				var pz = _server.getCurrentZone(); 
				var pr = pz.getRoomByName("ControlRoom"); 
				
				if (pr.getUserCount() >= this.populationLimit) { 
					_server.sendResponse( { _cmd: "logKOPop", txt: "Server Full!" }, -1, null, evtObj.chan, responseFormat);  
					_server.kickUser(evtObj.chan); 
					return; 
				}
			/* end Pop Limit Test */			
			var pass = evtObj.pass; 	// Uid or Memcache key
			var u = evtObj.user; 
			var serverIn = new LoadVars(), serverOut = new LoadVars();
			serverOut.uid = pass; 
			serverOut.cache = imageCache; 
			serverIn.onLoad = handleGetDataRequest; 
            serverOut.sendAndLoad(loginPageURL, serverIn, "post")
			serverIn.requestData = { nick: evtObj.nick, pass: evtObj.pass, chan: evtObj.chan, loginRequest: true } 
			
		}
		else if (evtObj.name == "userJoin") { 			
			var r = evtObj.room; 
			
			var u = evtObj.user; 
	if (captchaCheck) { 
				if (r.getName() != "ControlRoom" && u.properties.get('captchad') == false) {
					_server.banUser(u, 0, "I Hate You.", _server.BAN_BY_IP);
					return; 
				}
			}					
			var logt = new Date().valueOf(); 			
			u.properties.put('join_time', logt)			
			 
		} else if (evtObj.name == "userLost") { 
			if (evtObj.user.getVariable("silence")) removeFromSilenceArray(evtObj.user.getUserId());
		}

}
function addUserToRoom(uidList, uid) { 
	if (!uidList) return uid; 
	else return uidList + "," + u.getUserId;	
}
function removeUserFromRoom(uidList, uid) { 
	
}
function createPollData() { 
	var z = _server.getCurrentZone(); 
	var rs = z.getRooms(); 
	var l = rs.length;
	var reportStr = ""; 
	for (var i = 0;  i < l; i++) { 
		var r = rs[i]; 
		var rStr = "";
		var us = r.getAllUsers(); 
		var usl = us.length;
		var b = 0; 
		var rNameArr = r.getName().split(" "); 
		var rname = rNameArr.join("_");
		for (var usi = 0; usi < usl; usi++) { 
			if (us[usi].getVariable("$RB_castId")) b++; 
		}		
		rStr = rname + ":" + usl + " " + rname+ "broadcasting:" +  b ;
		reportStr += rStr + " ";
	}
	_server.writeFile("report.txt", reportStr, false); 
}
function handleGetDataRequest (success, errorMsg) { 	
				var data = new Object();  // User Vars
				var ent = new Object(); // entitlements
				if (this.fail) { 
					_server.sendResponse( { _cmd: "logKO", txt: this.fail}, -1, null, this.requestData.chan, responseFormat); 
				}
				if (this.abuse_type=='B') { 
						_server.sendResponse( { _cmd: "logBAN", txt: "You Have Been Banned"}, -1, null, this.requestData.chan, responseFormat); 
						return;  

				}
				if (this.chat_priv != "1") { 
						_server.sendResponse( {_cmd: "logPriv", txt: "No Chat in your Area"}, -1, null, this.requestData.chan, responseFormat); 
						return;  
				}
				data.sn = this.sn;
				data.psn = this.psn;
				data.loc = this.loc;
				data.hasImg = this.hasImg; 
				data.mh_id = Number(this.mh_id);
				data.buid = this.buid || "none"; 
				//data.logt = new Date().valueOf(); 
				data.ent = new Object(); 
				data.ent_init_block = this.init_block || 0;;
				ent.init_block = this.init_block || 0;
				ent.init_chat = this.init_chat || 0;;
				data.ent_init_chat = this.init_chat || 0;;
				ent.chat_admin = this.chat_admin || 0;;
				data.ent_chat_admin = this.chat_admin || 0;;
				ent.chat_priv = this.chat_priv || 0;; 
				data.ent.chat_priv = this.chat_priv || 0;; 
				ent.chat_occupancy = this.chat_occupancy || 0;
				data.ent_chat_occupancy = this.chat_occupancy || 0; 
				ent.chat_join_rooms = this.chat_join_rooms || 0;
				data.ent_chat_join_rooms = this.chat_join_rooms || 0; 				
				data.age = this.age; 
				if (imageCache) { data.img = this.img || null;  }
				if (data.sn != this.requestData.nick || data.mh_id != this.requestData.pass) { 
					_server.logger.info("Data Mismatch" + data.sn + "," + this.requestData.nick + "," + data.mh_id + "," + this.requestData.pass);
					 if (this.requestData.loginRequest) {
						 _server.sendResponse( { _cmd: "logKO", txt: "Data Mismatch" + data.sn + "," + this.requestData.nick + "," + data.mh_id + "," + this.requestData.pass }, -1, null, this.requestData.chan, responseFormat); 
					 }
					 return;  
				}
				if (this.requestData.loginRequest) { 
					var obj = _server.loginUser(this.requestData.nick , '', this.requestData.chan, true); 
					if (!obj.success) { 					
						_server.sendResponse( { _cmd: "logKO", txt: "Already Logged In"}, -1, null, this.requestData.chan, responseFormat); 
						return;  
					}
				}
				if (this.requestData.chan) 
					var u = _server.getUserByChannel(this.requestData.chan);
				else
					var u = this.requestData.user; 				
				if (this.requestData.loginRequest) {
					_server.sendResponse( { _cmd: "logOK", cache: imageCache, ent: ent, uid: u.getUserId() }, -1, null, this.requestData.chan, responseFormat);
					_server.setUserVariables(u, data, false); 
					u.properties.put("captchad", false); 
					if (this.abuse_type == 'S') { 				
						addToSilenceArray(data.mh_id, u.getUserId(), (this.abuse_end_unix * 1000) - new Date().valueOf()); 
						_server.sendResponse ( { _cmd: 'silence', additional: "You have been silenced from a previous offense. Please check your Manhunt mail for a message regarding this."}, -1, null, [u], "json"); 
						
					/*} else { 
						 /* DO THIS WHEN USER LOGS OFF IF THEY HAVE A SILENCE VARIABLE  */
					}
				} else { 
					_server.setUserVariables(u, data); 
				}
}

/*
 *
 *
 * Class for intrepreting JSON input
 *
 *
 */
