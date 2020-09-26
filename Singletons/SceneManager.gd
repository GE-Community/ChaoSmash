extends Node

func goto(location : String):
	match location:
		"MainMenu":
			get_tree().change_scene("res://Menu/MainMenu.tscn")
		"PlayMenu":
			get_tree().change_scene("res://Menu/PlayMenu.tscn")
