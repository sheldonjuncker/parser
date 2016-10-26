module parse.nodes.EqualsNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class EqualsNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	

	override void print()
	{
		write("( ");
		left.print();
		write(" == ");
		right.print();
		write(" )");
	}
}