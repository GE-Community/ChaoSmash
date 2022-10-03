extends Control

const bg_directory = "res://Assets/Art/UI/Background/"

# Onready Variables
onready var background_rect : TextureRect = $Background
onready var tagname_label : Label = $TagName

func _ready():
	randomize()
	set_background()
	set_tagname()
	$TagName/AnimationPlayer.play("Grow")

# Set a random background
func set_background():
	var dir = Directory.new()
	dir.open(bg_directory)
	dir.list_dir_begin(true)
	var file_name = dir.get_next()
	var backgrounds = []
	while file_name != "":
		if !dir.current_is_dir():
			backgrounds.append(load(bg_directory+file_name))
		file_name = dir.get_next()
	backgrounds.shuffle()
	var background_texture : Texture = backgrounds[0]
	background_rect.set_texture(background_texture)

func set_tagname():
	var file = File.new()
	file.open("res://Menu/Tags.csv", File.READ)
	var tagnames = []
	while !file.eof_reached():
		tagnames.append_array(file.get_csv_line())
	tagnames.shuffle()
	tagname_label.set_text(tagnames[0])

func _on_PlayBtn_pressed():
	SceneManager.goto("PlayMenu") # Changing scene to PlayMenu

func _on_SettingsBtn_pressed():
	pass # to be replaced by code for settings

func _on_QuitBtn_pressed():
	get_tree().quit() # Quit the game
