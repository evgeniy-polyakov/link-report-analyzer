package com.epolyakov.linkreportanalyzer.data
{
	/**
	 * @author epolyakov
	 */
	public class Definition
	{
		public var id:String;
		public var name:String;
		public var script:String;
		public var modified:Number = 0;
		public var size:int = 0;
		public var optimizedSize:int = 0;
		public var isExternal:Boolean;
		public var isPackage:Boolean;
		public var level:int;
		public var parent:Definition;
		public var children:Vector.<Definition> = new <Definition>[];
		public var dependencies:Vector.<Definition> = new <Definition>[];
		public var prerequisites:Vector.<Definition> = new <Definition>[];
	}
}