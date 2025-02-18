extends Node

# Nodes
@onready var email: LineEdit = $AspectRatioContainer/Control/VBoxContainer/Email
@onready var password: LineEdit = $AspectRatioContainer/Control/VBoxContainer/Password
@onready var output: TextEdit = $AspectRatioContainer/Control/VBoxContainer/HBoxContainer/Output


func _ready() -> void:
	Supabase.auth.connect("signed_up", Callable(self, "_on_signed_up"))
	Supabase.auth.connect("signed_in", Callable(self, "_on_signed_in"))
	Supabase.auth.connect("error", Callable(self, "_on_error"))


func _process(delta: float) -> void:
	pass


func _on_register_pressed() -> void:
	if !is_email_valid() or !is_password_valid():
		return
	Supabase.auth.sign_up(email.text, password.text)
	output.text = "loading"


func _on_login_pressed() -> void:
	if !is_email_valid() or !is_password_valid():
		return
	Supabase.auth.sign_in(email.text, password.text)
	output.text = "loading"


func is_password_valid() -> bool:
	if password.text.length() < 6:
		output.text = "password size must be Greater than 6"
		return 0
	output.text = ""
	return 1


func is_email_valid() -> bool:
	if !email.text.ends_with("iiit.ac.in"):
		output.text = "enter a valid iiit.ac.in email"
		return 0
	output.text = ""
	return 1


func _on_signed_up(user : SupabaseUser):
	output.text = "Signed Up as "+str(user)


func _on_signed_in(user : SupabaseUser):
	output.text = "Signed In as "+str(user) 


func _on_error(Error):
	output.text = "Error : "+str(Error)
