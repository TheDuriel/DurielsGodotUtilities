extends Node


	#the prefix used for groups.
	#set this to something that you are definitly not going to use manually
const PREFIX = "ANNOUNCE_"


	#the types of messages
enum {GENERIC,
	EVENTBUTTON_ADD,
	EVENTBUTTON_RESET,
	EVENTBUTTON_OUTPUT,
	EVENTACTION}


	#subscribes a given node to a particular message type
	#when a message of that type is sent to the announcer
	#it will call the _announcement(type, data) function
	# in all nodes subscribed to that message type
func subscribe(node, message_type):
	if not node.is_in_group(PREFIX + str(message_type)):
		node.add_to_group(PREFIX + str(message_type))


	#unsubscribe a given node from a particular message type
func unsubscribe(node, message_type):
	if node.is_in_group(PREFIX + str(message_type)):
		node.remove_from_group(PREFIX + str(message_type))


	#send a message to all subscribed nodes
	#announcements are recieved via the announcement function
func announce(message_type, data):
	var type = PREFIX + str(message_type)
	get_tree().call_group(type, "_announcement", message_type, data)


	#add this function to any node that has been subscribed to this singleton
	#it will then be called every time an announcement is made
#func announcement(message_type, data):
	#pass