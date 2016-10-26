module parse.nodes.OrNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class OrNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	

	override void print()
	{
		write("( ");
		left.print();
		write(" || ");
		right.print();
		write(" )");
	}
}