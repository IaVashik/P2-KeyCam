IncludeScript("demo/utils")

keypoints <- [] // список ключевых точек для камеры
isRecording <- true // true - включить запись / false - выключить
currentKey <- 0  // индекс текущей точки
progress <- 0 // прогресс от 0 до 1 между двумя точками 
progress_speed <- 0.001 // скорость прогресса

function AddKeyPoint()
{
    keypoints.append( {origin=EyePos(),angles=EyeAngles()} ) // добавить новую точку с текущим положением и углом глаз
    log("Create new key: origin- "+EyePos()+", angles- "+EyeAngles())
}

function StartPlaying( linear )
{
    // SC("exec screenshot") TODO
    EntFire("camera","Enable") // включить камеру
    isRecording = false
    progress=0
    currentKey=0
    SetCameraPosition( linear ) // установить позицию камеры в зависимости от режима
    camera.SetOrigin(keypoints[currentKey].origin) // установить начальную позицию камеры
    SetAnglesV(camera,keypoints[currentKey].angles) // установить начальный угол камеры
}

function SetCameraPosition(mode) // mode - true - линейное движение; false - плавное движение
{
    if(currentKey!=keypoints.len()-1 && !isRecording) // если не достигнута последняя точка
    {
        if(TraceGetDist(camera.GetOrigin(),keypoints[currentKey+1].origin)<1) // если расстояние до следующей точки меньше 1
        {
            currentKey++ // перейти к следующей точке
            progress=0 // сбросить прогресс
        }

        progress += progress_speed
        camera.SetOrigin( lerpVector(keypoints[currentKey].origin, keypoints[currentKey+1].origin,progress) ) // линейно интерполировать позицию камеры между двумя точками
        
        local q1 = Quaternion().new(keypoints[currentKey].angles)
        local q2 = Quaternion().new(keypoints[currentKey+1].angles)
        local slerp = q1.slerp(q2, progress).toVector()
        
        SetAnglesV(camera, slerp) // линейно интерполировать угол камеры между двумя точками
        
        script_delay("SetCameraPosition("+mode+")", FrameTime()) // повторить функцию через время кадра
    }
    else 
    {
        isRecording = true; 
        log("DISABLE");
        EntFire("camera", "Disable")
        SC("exec screenshot_off")
    }
}

function DrawKey()
{
    script_delay("DrawKey()", 0.2)
    if(!isRecording || keypoints.len()==0) return
    foreach (k,vector in keypoints) {
        vector = vector.origin
        DebugDrawBox(vector,Vector(4,4,4),Vector(-4,-4,-4), 171, 214, 213, 100, 0.25)
        if(k!=0 && k!=keypoints.len()) DebugDrawLine(keypoints[k-1].origin, vector, 224, 216, 232, false, 0.25)
    }
    DebugDrawLine(keypoints.top().origin, EyePos(), 50, 216, 0, false, 0.25)
    log(TraceGetDist(EyePos(),keypoints.top().origin))
}
DrawKey()

SC("sv_alternateticks 0")