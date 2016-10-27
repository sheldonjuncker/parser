module parser.nodes.WhileNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

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