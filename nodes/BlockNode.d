module parser.nodes.BlockNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class BlockNode : Node
{
	Node[] stmts;

	this(TokenLocation location, Node[] stmts)
	{
		this.location = location;
		this.stmts = stmts;
	}

	override void print()
	{
		writeln("{");
		foreach(Node node; stmts)
		{
			//Won't work for nested blocks.
			write("\t");
			node.print();
			write("\n");
		}
		writeln("}");
	}
}