module parse.nodes.IfNode;
import parse.nodes.node;

class IfNode : Node
{
	Node cond;
	Node stmt;

	this(TokenLocation location, Node cond, Node stmt)
	{
		this.location = location;
		this.cond = cond;
		this.stmt = stmt;
	}

	override void print()
	{
		write("if( ");
		cond.print();
		write(" )\n");
		stmt.print();
	}
}