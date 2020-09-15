extends "res://Characters/BaseFighter/Fighter.gd" #Extending Fighter Script

func _ready():
	connect("move", self, "Move", [])#Connecting Move Signal
	connect("jump", self, "Jump")#Connecting Jump Signal

func Move(direction):
	print(direction)

func Jump():
	print("Jumping")
