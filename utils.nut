// if(!IsMultiplayer)
// {
//     player <- GetPlayer()
// }
// else
// {
//     player <- Entities.FindByName(null, "blue")
// }
player <- GetPlayer()

function EFBCN(classname) return Entities.FindByClassname(null, classname)
function EFBN(targetname) return Entities.FindByName(null, targetname)
function SetName(target,name) target.__KeyValueFromString("targetname", name)
function SC(command) {SendToConsole(command)}
function SetAnglesV(ent,vec) ent.SetAngles(vec.x,vec.y,vec.z)
function TraceGetDist(start,end) return (start - end).Length()
function EyeAngles() return EFBN("trc_eye_target").GetAngles()
function EyePos() return player.EyePosition()
function lerp(start, end, t) return start * (1 - t) + end * t;
function lerpVector(start, end, t) return Vector(lerp(start.x,end.x,t),lerp(start.y,end.y,t),lerp(start.z,end.z,t))

function script_delay(script,delay) {
    local allscript = split(script,";");allscript = split(script,";");
    foreach (xxc in allscript) EntFire("Consoler","command","script "+xxc,delay)
}

function log(msg) 
    if(developer()!=0) printl(msg)


SetName(eye <- Entities.CreateByClassname( "logic_measure_movement" ),"trc_eye")
SetName(eye_point <- Entities.CreateByClassname( "info_target" ),"trc_eye_target")
eye.__KeyValueFromInt("measuretype", 1)
EntFire("trc_eye","setmeasuretarget", "!player");
EntFire("trc_eye","setmeasurereference", "trc_eye");
EntFire("trc_eye","SetTargetReference", "trc_eye");
EntFire("trc_eye","Settarget", "trc_eye_target");
EntFire("trc_eye","Enable")

SetName(Consoler <- Entities.CreateByClassname( "point_servercommand" ),"Consoler")
SetName(camera <- Entities.CreateByClassname( "point_viewcontrol" ),"camera")