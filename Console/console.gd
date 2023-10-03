extends CanvasLayer

@export_category("Commands")
@export var commands : Array[ConsoleCommand]

@export_category("Settings")
@export var ActivateKey : String
@export var SaveLogFile : bool
@export var LogSaveTime : float = 30.0
@export var PauseOnActivate : bool


@onready var container = $MarginContainer
@onready var text = $MarginContainer/VBoxContainer/TextEdit
@onready var input = $MarginContainer/VBoxContainer/LineEdit
@onready var anim = $AnimationPlayer
@onready var saveTimer = $SaveTimer

const VERSION = "0.1"

var isVisible : bool = false
var timestamp 

var vars = {
	
}

var consts = {
	
}
	
func _ready() -> void:
	Console.currentViewport = get_viewport()
	isVisible = false
	container.position.y = -400
	saveTimer.one_shot = true
	timestamp = Time.get_unix_time_from_system()
	
	if (SaveLogFile):
		saveTimer.start(LogSaveTime)
	
	
func _process(_delta) -> void:
	text.scroll_vertical = INF
	if ActivateKey=="":
		return
		
	if Input.is_action_just_pressed(ActivateKey):
		if isVisible:
			Hide()
		else:
			Show()
			

func Show() -> void:
	anim.play("show")
	isVisible = true
	input.grab_focus()
	if (PauseOnActivate):
		get_tree().paused=true
	
	
func Hide() -> void:
	anim.play("hide")
	isVisible = false
	if (PauseOnActivate):
		get_tree().paused=false


func AddLog(_log : String) -> void:
	text.text += _log + "\n"
	

func RegVar(varName:String,value) -> void:
	vars[varName] = value
	
func GetVar(varName:String):
	return vars[varName]
	
func RegConst(constName : String,value) -> void:
	consts[constName] = value
	
func GetConst(constName : String):
	return consts[constName]
	
		
func _on_line_edit_text_submitted(new_text : String):
	text.text += input.text + "\n"
	_parseFunctions(new_text)	
	input.text = ""


func _parseFunctions(functext : String) -> void:
	# inbuild functions
	# -help			- help screen
	# -funcs		- available registered functions
	# -vars			- available registered variables
	# -constants	- available registered constants
	if functext == "-help":
		AddLog("RoughCon - Godot4 Ingame Console")
		AddLog("Version " + VERSION)
		AddLog("https://roughnight.itch.io/")
	elif functext == "-funcs":
		for f in commands:
			AddLog("Script: " + f.command_script)
			for ff in f.command_name:
				AddLog("Command: " + ff)
				
	elif functext == "-vars":
		var keys = vars.keys()
		for k in keys:
			AddLog(k)
	elif functext == "-constants":
		var keys = consts.keys()
		for k in keys:
			AddLog(k)
	else:
		for a in commands:
			for c in a.command_name:
				var l = functext.split(" ")
				if c==l[0]:
					# check for consts
					var constfound : bool = false
					for cindex  in range(1,l.size()):
						var keys = consts.keys()
						for n in keys:
							constfound = false
							if l[cindex]==n:
								constfound = true
								var new_functext = functext.split(" ")
								new_functext[cindex] = _trimParameters(str(consts[n]))
								functext=""
								for f in new_functext:
									functext +=f + " "
					if constfound==false:
						# check for vars
						var foundvar : bool = false
						for pindex in range(1,l.size()):
							var keys = vars.keys()
							var varname : String
							var varpos : int
							for n in keys:
								foundvar = false
								if l[pindex]==n:
									# found var
									foundvar=true
								if not foundvar:
									var splitted = l[pindex].split(".")
									if splitted:
										if splitted[0]==n:
											foundvar=true
											varname = n
											varpos = pindex
											var new_functext = functext.split(" ")
											new_functext[varpos] = _trimParameters(str(vars[varname].get(splitted[1])))
											functext=""
											for f in new_functext:
												functext +=f + " "
											
					var ret = a.execute(functext)
					if ret:
						text.text += str(ret) +"\n"
						
						
				
func _trimParameters(_input:String) -> String:
	return _input.replace(" ","").replace("(","").replace(")","")
			
			
func _saveLogFile(filename : String = "") -> void:
	if not DirAccess.dir_exists_absolute("res://logs"):
		var dir = DirAccess.open("res://")
		dir.make_dir("logs")
		
	var f
	if filename.is_empty():
		f = FileAccess.open("res://logs/log"+str(timestamp)+".txt",FileAccess.WRITE)
	else:
		f = FileAccess.open("res://logs/"+filename,FileAccess.WRITE)
		
	f.store_string(text.text)
	f.close()
	

func _on_save_timer_timeout():
	saveTimer.start(LogSaveTime)
	_saveLogFile()
