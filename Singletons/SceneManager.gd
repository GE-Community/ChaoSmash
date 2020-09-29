extends CanvasLayer

# Variables
var nextScene : String = ""

# Onready Variables
onready var color_rect : ColorRect = $ColorRect
onready var anim_player : AnimationPlayer= $ColorRect/AnimationPlayer
onready var change_timer : Timer = $ChangeTimer

func goto(location : String):
	color_rect.show()
	anim_player.play("TansAnim")
	change_timer.start()
	nextScene = location

func _on_AnimationPlayer_animation_finished(anim_name):
	color_rect.hide()

func _on_ChangeTimer_timeout():
	match nextScene:
		"MainMenu":
			get_tree().change_scene("res://Menu/MainMenu.tscn")
		"PlayMenu":
			get_tree().change_scene("res://Menu/PlayMenu.tscn")
		"Debug Stage":
			get_tree().change_scene("res://Stages/DebugStage/DebugStage.tscn")
