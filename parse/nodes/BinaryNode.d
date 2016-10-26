module parse.nodes.BinaryNode;
import parse.nodes.node;

class BinaryNode : Node
{
	Node left;
	Node right;

	this(Node left, Node right)
	{
		this.left = left;
		this.right = right;
	}
}