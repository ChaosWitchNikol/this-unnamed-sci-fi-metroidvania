extends Object
class_name Utils

# get all nodes of certain type
static func get_node_children_by_type(parent_node : Node, type : String) -> Array:
	var found_children = Array()
	
	for child in parent_node.get_children():
		if child.get_class() == type:
			found_children.append(child)
	
	return found_children




class OrderNumberSorter:
	static func sort(a, b):
		return a.ORDER_NUMBER < b.ORDER_NUMBER
static func sort_nodes_by_order_number(nodes : Array) -> Array:
	nodes.sort_custom(OrderNumberSorter, "sort")
	return nodes