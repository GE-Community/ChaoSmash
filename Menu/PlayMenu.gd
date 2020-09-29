extends Control

# Variables
var backgrounds : Array = ["res://Assets/Art/UI/Background/menu2.png",
"res://Assets/Art/UI/Background/menu.png"]

# Onready Variables
onready var background_node : TextureRect = $Background

func _ready():
	randomize() #Using Randomize so that rand_range gives random results every time
	var background : int = round(rand_range(0, backgrounds.size()-1)) # Getting a random index for background
	var background_texture : Texture = load(backgrounds[background]) # Loading background texture
	background_node.set_texture(background_texture) # Setting background


func _on_CreateRoomBtn_pressed():
	pass # To be replaced by kevin's multiplayer code

func _on_JoinRoomBtn_pressed():
	pass # To be replaced by kevin's multiplayer code

func _on_OfflineBtn_pressed():
	SceneManager.goto("Debug Stage") # Change Scene to Debug Stage

func _on_TrainingBtn_pressed():
	SceneManager.goto("Debug Stage") # Change Scene to Debug Stage

func _on_BackBtn_pressed():
	SceneManager.goto("MainMenu") # Change Menu To Main Menu
