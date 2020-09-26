extends Control

# Variables
var backgrounds : Array = ["res://Menu/Backgrounds/menu.png", "res://Menu/Backgrounds/menu2.png"]

# Onready Variables
onready var background_node : TextureRect = $Background

func _ready():
	randomize() #Using Randomize so that rand_range gives random results every time
	var background : int = round(rand_range(0, backgrounds.size()-1)) # Getting a random index for background
	var background_texture : Texture = load(backgrounds[background]) # Loading background texture
	background_node.set_texture(background_texture) # Setting background

func _on_PlayBtn_pressed():
	SceneManager.goto("PlayMenu") # Changing scene to PlayMenu

func _on_SettingsBtn_pressed():
	pass # to be replaced by code for settings

func _on_QuitBtn_pressed():
	get_tree().quit() # Quit the game
