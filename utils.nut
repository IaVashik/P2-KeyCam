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

class Quaternion
{
    quaternion = null 

    constructor(quaternion = null) {
        this.quaternion = quaternion
    }

    function new(angles) {
        local pitch = angles.z * 0.5 / 180 * PI
        local yaw = angles.y * 0.5 / 180 * PI
        local roll = angles.x * 0.5 / 180 * PI

        local sRoll = sin(roll);
        local cRoll = cos(roll);
        local sPitch = sin(pitch);
        local cPitch = cos(pitch);
        local sYaw = sin(yaw);
        local cYaw = cos(yaw);

        this.quaternion = {
            x = cYaw * cRoll * sPitch - sYaw * sRoll * cPitch,
            y = cYaw * sRoll * cPitch + sYaw * cRoll * sPitch,
            z = sYaw * cRoll * cPitch - cYaw * sRoll * sPitch,
            w = cYaw * cRoll * cPitch + sYaw * sRoll * sPitch
        }

        return this
    }

    function multiplyQuaternions(q1, q2) {
        return {
            x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
            y = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x,
            z = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w,
            w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z
        }
    }

    function rotateVector(vec) {
        // Конвертируем вектор в кватернион
        local vecQuaternion = { x = vec.x, y = vec.y, z = vec.z, w = 0 };

        // Находим обратный кватернион
        local inverse = {
            x = -this.quaternion.x,
            y = -this.quaternion.y,
            z = -this.quaternion.z,
            w = this.quaternion.w
        };

        // Применяем кватернионные преобразования к вектору
        local rotatedQuaternion = multiplyQuaternions(multiplyQuaternions(this.quaternion, vecQuaternion), inverse);

        // Возвращаем результат в виде повернутого вектора
        return Vector(rotatedQuaternion.x, rotatedQuaternion.y, rotatedQuaternion.z);
    }

    function unrotateVector(vec) {
        // Находим конъюгированный кватернион
        local conjugateQuaternion = {
            x = -this.quaternion.x,
            y = -this.quaternion.y,
            z = -this.quaternion.z,
            w = this.quaternion.w
        };

        // Конвертируем вектор в кватернион
        local vecQuaternion = { x = vec.x, y = vec.y, z = vec.z, w = 0 };

        // Применяем кватернионные преобразования к вектору с обратными углами поворота
        local unrotatedQuaternion = multiplyQuaternions(multiplyQuaternions(conjugateQuaternion, vecQuaternion), this.quaternion);

        // Возвращаем результат в виде "унротейтнутого" вектора
        return Vector(unrotatedQuaternion.x, unrotatedQuaternion.y, unrotatedQuaternion.z);
    }

    function slerp(targetQuaternion, t) {
        local quaternion1 = this.quaternion
        local quaternion2 = targetQuaternion.get_table()

        // Нормализуем кватернионы
        quaternion1 = _normalizeQuaternion(quaternion1);
        quaternion2 = _normalizeQuaternion(quaternion2);

        // Находим угол между кватернионами
        local cosTheta = quaternion1.x * quaternion2.x + quaternion1.y * quaternion2.y + quaternion1.z * quaternion2.z + quaternion1.w * quaternion2.w;

        // Если угол отрицательный, меняем знак у второго кватерниона
        if (cosTheta < 0) {
            quaternion2.x *= -1;
            quaternion2.y *= -1;
            quaternion2.z *= -1;
            quaternion2.w *= -1;
            cosTheta *= -1;
        }

        // Находим значения для интерполяции
        local theta = acos(cosTheta);
        local sinTheta = sin(theta);
        local weight1 = sin((1 - t) * theta) / sinTheta;
        local weight2 = sin(t * theta) / sinTheta;

        // Интерполируем кватернионы
        local resultQuaternion = {
            x = weight1 * quaternion1.x + weight2 * quaternion2.x,
            y = weight1 * quaternion1.y + weight2 * quaternion2.y,
            z = weight1 * quaternion1.z + weight2 * quaternion2.z,
            w = weight1 * quaternion1.w + weight2 * quaternion2.w
        };

        // Нормализуем результат
        local result = _normalizeQuaternion(resultQuaternion)
        return Quaternion(result);
    }

    function _normalizeQuaternion(quaternion) {
        local magnitude = sqrt(quaternion.x * quaternion.x + quaternion.y 
            * quaternion.y + quaternion.z * quaternion.z + quaternion.w * quaternion.w);

        return {
            x = quaternion.x / magnitude,
            y = quaternion.y / magnitude,
            z = quaternion.z / magnitude,
            w = quaternion.w / magnitude
        }
    }

    function Norm() {
        return _normalizeQuaternion(this.quaternion)
    }

    function toVector() {
        local sinr_cosp = 2 * (quaternion.w * quaternion.x + quaternion.y * quaternion.z);
        local cosr_cosp = 1 - 2 * (quaternion.x * quaternion.x + quaternion.y * quaternion.y);
        local roll = atan2(sinr_cosp, cosr_cosp);

        local sinp = 2 * (quaternion.w * quaternion.y - quaternion.z * quaternion.x);
        local pitch;
        if (abs(sinp) >= 1) {
            pitch = copysign(PI / 2, sinp); // Пи/2 или -Пи/2
        } else {
            pitch = asin(sinp);
        }

        local siny_cosp = 2 * (quaternion.w * quaternion.z + quaternion.x * quaternion.y);
        local cosy_cosp = 1 - 2 * (quaternion.y * quaternion.y + quaternion.z * quaternion.z);
        local yaw = atan2(siny_cosp, cosy_cosp);

        // Преобразуем углы в градусы
        local x = pitch * 180 / PI;
        local y = yaw * 180 / PI;
        local z = roll * 180 / PI;

        return Vector( x, y, z )
    }

    function _mul(other) {
        return Quaternion(multiplyQuaternions(this.quaternion, other))
    }

    function _tostring() {
        local x = this.quaternion.x;
        local y = this.quaternion.y;
        local z = this.quaternion.z;
        local w = this.quaternion.w;
        return "Quaternion: (" + x + ", " + y + ", " + z + ", " + w + ")"
    }

    function x() {
        return this.quaternion.x;
    }

    function y() {
        return this.quaternion.y;
    }

    function z() {
        return this.quaternion.z;
    }

    function w() {
        return this.quaternion.w;
    }

    function get_table() {
        return {
            x = this.quaternion.x,
            y = this.quaternion.y,
            z = this.quaternion.z,
            w = this.quaternion.w
        }
    }
}


