extends Node

# Nodes
@onready var email: LineEdit = $AspectRatioContainer/Control/VBoxContainer/Email
@onready var password: LineEdit = $AspectRatioContainer/Control/VBoxContainer/Password
@onready var output: TextEdit = $AspectRatioContainer/Control/VBoxContainer/HBoxContainer/Output


func _ready() -> void:
	Supabase.auth.connect("signed_up", Callable(self, "_on_signed_up"))
	Supabase.auth.connect("signed_in", Callable(self, "_on_signed_in"))


func _process(delta: float) -> void:
	pass


func _on_register_pressed() -> void:
	Supabase.auth.sign_up(email.text, password.text)


func _on_login_pressed() -> void:
	Supabase.auth.sign_in(email.text, password.text)


func _on_signed_up():
	print("Signed up!")
	output.text = "Signed Up!"


func _on_signed_in():
	print("Signed in!")
	output.text = "Signed In!"
