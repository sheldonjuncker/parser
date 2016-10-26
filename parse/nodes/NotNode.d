module parse.nodes.NotNode;
import parse.nodes.node;

class NotNode : Node
{
	Node right;
	this(Node right)
	{
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