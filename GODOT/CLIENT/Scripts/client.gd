extends Node

@onready var counter: Button = $Background/Counter
@onready var checker: Button = $Background/Checker

var debug_count = 0
var socket = WebSocketMultiplayerPeer.new()


func _ready() -> void:
	var client = socket.create_client(Secure.CLIENT_IP)
	if client != OK :
		print("there was a connection issue for CLIENT")
		pass
	print("CLIENT CONNECTED")


func _process(delta: float) -> void:
	socket.poll()
	if socket.get_available_packet_count() != 0:
		var peer_id = socket.get_packet_peer()
		var packet = socket.get_packet()
		_on_network_peer_packet(peer_id, packet)


func _on_network_peer_packet(peer_id, packet):
	var message = packet.get_string_from_utf8()
	print("Received from server: ", message)
	counter.text = "COUNTER: " + message


func _on_clicky_pressed() -> void:
	#debug counter
	debug_count += 1
	checker.text = str(debug_count)
	
	print("Sending 'press_button' message to server")
	socket.set_target_peer(1)
	socket.put_packet("press_button".to_utf8_buffer())
