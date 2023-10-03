extends Node

# standard commands for RoughCon

func setResolution(params) -> void:
	var resx = int(params[0])
	var resy = int(params[1])
	if (Console.currentViewport):
		Console.currentViewport.content_scale_size = Vector2(resx,resy)
	DisplayServer.window_set_size(Vector2i(resx,resy))


func setFullscreen(params) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
