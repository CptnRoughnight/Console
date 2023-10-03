class_name ConsoleCommand extends Resource

@export var command_script : String
@export var command_name : Array[String] 

func execute(exCom) :
	var sc = load(command_script)
	var s = sc.new()
	var l = exCom.split(" ",false)
		
	var params = []
	for f in range(1,l.size()):
		params.append(l[f])
		
	return s.call(l[0],params)
