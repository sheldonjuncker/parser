module parser.nodes.AssignNode;
import parser.nodes.node;
import parser.nodes.BinaryNode;
import lexer.token;
import std.stdio;
import std.exception;

class AssignNode : BinaryNode
{
	this(TokenLocation location, Node left, Node right)
	{
		super(location, left, right);
	}

	override void print(int tabs=0)
	{
		write("(");
		left.print(tabs);
		write(" = ");
		right.print(tabs);
		write(")");
	}

	override void analyzeVariables(Environment e)
	{
		super.analyzeVariables(e);

		//Verify that the left side is an lvalue
		if(!left.isLvalue())
		{
			throw new LvalueAssignmentException(location);
		}
	}
}