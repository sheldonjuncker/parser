module parse.nodes.WhileNode;
import parse.nodes.node;

class WhileNode : Node
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
		write("while( ");
		cond.print();
		write(" )\n");
		stmt.print();
	}
}