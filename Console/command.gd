class_name ConsoleCommand extends Resource

@export var command_script : String
@export var command_name : Array[String] 

func execute(exCom) -> void:
	var sc = load(command_script)
	var s = sc.new()
	var l = exCom.split(" ",false)
		
	var params = []
	for f in range(1,l.size()):
		params.append(l[f])
		
	s.call(l[0],params)
