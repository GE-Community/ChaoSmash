extends Control

# Variables
var backgrounds : Array = ["res://Assets/Art/UI/Background/menu2.png",
"res://Assets/Art/UI/Background/menu.png"]
var tween_vals = [Vector2(0.8, 0.8), Vector2(1, 1)]

#Consts
const TRANS = Tween.TRANS_QUAD
const EASE = Tween.EASE_IN_OUT
const DURATION = 1

# Onready Variables
onready var background_node : TextureRect = $Background
onready var tagname_label : Label = $TagName
onready var tagname_tween : Tween = $TagNameTween


func _ready():
	randomize() #Using Randomize so that rand_range gives random results every time
	var background : int = round(rand_range(0, backgrounds.size()-1)) # Getting a random index for background
	var background_texture : Texture = load(backgrounds[background]) # Loading background texture
	background_node.set_texture(background_texture) # Setting background
	var tagname_file = File.new()
	tagname_file.open("res://Menu/Tagname.json", File.READ)
	var tempdata = parse_json(tagname_file.get_as_text())
	var tagname_text = tempdata["tagnames"]
	tagname_text.shuffle()
	tagname_label.set_text(tagname_text[0])
	tagname_tween.interpolate_property(tagname_label, "rect_scale", tween_vals[0], tween_vals[1], DURATION, TRANS, EASE)
	tagname_tween.start()

func _on_PlayBtn_pressed():
	SceneManager.goto("PlayMenu") # Changing scene to PlayMenu

func _on_SettingsBtn_pressed():
	pass # to be replaced by code for settings

func _on_QuitBtn_pressed():
	get_tree().quit() # Quit the game

func _on_TagNameTween_tween_completed(object, key):
	var temp = tween_vals[0]
	tween_vals[0] = tween_vals[1]
	tween_vals[1] = temp
	tagname_tween.interpolate_property(tagname_label, "rect_scale", tween_vals[0], tween_vals[1], DURATION, TRANS, EASE)
	tagname_tween.start()
