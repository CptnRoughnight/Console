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

var isVisible : bool = false

var timestamp 
	
func _ready() -> void:
	isVisible = false
	container.position.y = -400
	saveTimer.one_shot = true
	timestamp = Time.get_unix_time_from_system()
	if (SaveLogFile):
		saveTimer.start(LogSaveTime)
	
	
func _process(_delta) -> void:
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


func AddLog(log : String) -> void:
	text.text += log + "\n"
	
	
func _on_line_edit_text_submitted(new_text : String):
	_parseFunctions(new_text)
	text.text += input.text + "\n"
	input.text = ""


func _parseFunctions(text : String) -> void:
	for a in commands:
		for c in a.command_name:
			var l = text.split(" ")
			if c==l[0]:
				a.execute(text)
				
			
func _saveLogFile() -> void:
	if not DirAccess.dir_exists_absolute("res://logs"):
		var dir = DirAccess.open("res://")
		dir.make_dir("logs")
		
	var f = FileAccess.open("res://logs/log"+str(timestamp)+".txt",FileAccess.WRITE)
	f.store_string(text.text)
	f.close()
	

func _on_save_timer_timeout():
	saveTimer.start(LogSaveTime)
	_saveLogFile()
