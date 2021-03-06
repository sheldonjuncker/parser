module parser.nodes.VarDeclareNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;
import semantic.variable;

class VarDeclareNode : Node
{
	///Name of variable
	string name;

	this(TokenLocation location, string name)
	{
		this.location = location;
		this.name = name;
	}

	override void print(int tabs=0)
	{
		write("var " ~ name);
	}
	
	override void analyzeVariables(Environment e)
	{
		//Test to see if the variable exists in this scope
		SemanticVar var = e.getVar(name, true);
		
		//Add it
		if(var is null)
		{
			e.addVar(name, new SemanticVar(this));
		}

		//Cannot redeclare variable
		else
		{
			throw new VarRedeclareException(name, location);
		}
	}

	override bool hasEffect()
	{
		return semInfo.uses > 0;
	}
}