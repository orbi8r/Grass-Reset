extends Node

@onready var counter_display: Button = $"Background/Counter Display"

var counter = 0
var peers = []

var socket = WebSocketMultiplayerPeer.new()


func _ready() -> void:
	var server = socket.create_server(Secure.PORT, "*")
	if server != OK :
		print("There was an Error Creating SERVER")
		pass
	print("Created SERVER")
	
	socket.connect("peer_connected", Callable(self, "_on_peer_connected"))
	socket.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))
	
	set_process(true)


func _process(delta: float) -> void:
	socket.poll()
	if socket.get_available_packet_count() != 0:
		var peer_id = socket.get_packet_peer()
		var packet = socket.get_packet()
		_on_network_peer_packet(peer_id, packet)
	counter_display.text = "COUNTER : "+str(counter)


func _on_peer_connected(peer_id):
	print("Peer connected with ID: ", peer_id)
	peers.append(peer_id)
	broadcast_counter()


func _on_peer_disconnected(peer_id):
	print("Peer disconnected with ID: ", peer_id)
	peers.erase(peer_id)


func _on_network_peer_packet(peer_id, packet):
	var message = packet.get_string_from_utf8()
	print("Received from peer ", peer_id, " : ", message)
	
	if message == "press_button":
		counter += 1
		broadcast_counter()


func broadcast_counter():
	var message = str(counter)
	var message_buffer = message.to_utf8_buffer()
	print("Broadcasting message: ", message)  # Debug: print the message
	for peer_id in peers:
		socket.set_target_peer(peer_id)
		socket.put_packet(message_buffer)
