module parse.nodes.NotNode;
import parse.nodes.node;

class NotNode : Node
{
	Node right;
	this(TokenLocation location, Node right)
	{
		this.location = location;
		this.right = right;
	}	

	override void print()
	{
		write("( ");
		write("! ");
		right.print();
		write(" )");
	}
}