module parse.nodes.MulNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class MulNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" * ");
		right.print();
		write(" )");
	}
}