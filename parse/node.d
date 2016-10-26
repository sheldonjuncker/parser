module parse.node;
import std.conv;
import std.stdio;

/**
* Represents a node of the AST.
*/
class Node
{
	/**
	* Prints out a representation of a node.
	* Used in debugging to make sure that precedence was matched correctly.
	*/
	void print()
	{

	}
}

class BlockNode : Node
{
	Node[] stmts;

	this(Node[] stmts)
	{
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

class IfNode : Node
{
	Node cond;
	Node stmt;

	this(Node cond, Node stmt)
	{
		this.cond = cond;
		this.stmt = stmt;
	}

	override void print()
	{
		write("if( ");
		cond.print();
		write(")\n");
		stmt.print();
	}
}

class WhileNode : Node
{
	Node cond;
	Node stmt;

	this(Node cond, Node stmt)
	{
		this.cond = cond;
		this.stmt = stmt;
	}

	override void print()
	{
		write("while( ");
		cond.print();
		write(")\n");
		stmt.print();
	}
}

class BinaryNode : Node
{
	Node left;
	Node right;

	this(Node left, Node right)
	{
		this.left = left;
		this.right = right;
	}
}

class AndNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" && ");
		right.print();
		write(" )");
	}
}

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

class XorNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	

	override void print()
	{
		write("( ");
		left.print();
		write(" ^^ ");
		right.print();
		write(" )");
	}	
}

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

class GtNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" > ");
		right.print();
		write(" )");
	}
}

class LtNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	

	override void print()
	{
		write("( ");
		left.print();
		write(" < ");
		right.print();
		write(" )");
	}
}

class GteNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	

	override void print()
	{
		write("( ");
		left.print();
		write(" >= ");
		right.print();
		write(" )");
	}
}

class LteNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	


	override void print()
	{
		write("( ");
		left.print();
		write(" <= ");
		right.print();
		write(" )");
	}
}

class AddNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" + ");
		right.print();
		write(" )");
	}	
}

class SubNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" - ");
		right.print();
		write(" )");
	}	
}

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

class DivNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" / ");
		right.print();
		write(" )");
	}	
}

class ModNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" % ");
		right.print();
		write(" )");
	}	
}

class AssignNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" = ");
		right.print();
		write(" )");
	}
}

class IdentNode : Node
{
	string ident;
	this(string ident)
	{
		this.ident = ident;
	}

	override void print()
	{
		write(ident);
	}	
}

class NumNode : Node
{
	double num;
	this(string num)
	{
		this.num = to!double(num); 
	}	

	override void print()
	{
		write(num);
	}
}

class StringNode : Node
{
	string str;
	this(string str)
	{
		this.str = str;
	}	

	override void print()
	{
		write("\"" ~ str ~ "\"");
	}
}

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