package com.epolyakov.linkreportanalyzer.data
{
	/**
	 * @author epolyakov
	 */
	public class DefinitionSort
	{
		private var _comparators:Vector.<Function> = new <Function>[];

		public function get byPackage():DefinitionSort
		{
			_comparators.push(function (a:Definition, b:Definition):int
							  {
								  if (a.isPackage && !b.isPackage)
								  {
									  return -1;
								  }
								  else if (!a.isPackage && b.isPackage)
								  {
									  return 1;
								  }
								  return 0;
							  });
			return this;
		}

		public function get byExternal():DefinitionSort
		{
			_comparators.push(function (a:Definition, b:Definition):int
							  {
								  if (!a.isExternal && b.isExternal)
								  {
									  return -1;
								  }
								  else if (a.isExternal && !b.isExternal)
								  {
									  return 1;
								  }
								  return 0;
							  });
			return this;
		}

		public function get byId():DefinitionSort
		{
			_comparators.push(function (a:Definition, b:Definition):int
							  {
								  var A:String = a.id.toLowerCase();
								  var B:String = b.id.toLowerCase();
								  if (A < B)
								  {
									  return -1;
								  }
								  else if (A > B)
								  {
									  return 1;
								  }
								  return 0;
							  });
			return this;
		}

		public function get byName():DefinitionSort
		{
			_comparators.push(function (a:Definition, b:Definition):int
							  {
								  var A:String = a.name.toLowerCase();
								  var B:String = b.name.toLowerCase();
								  if (A < B)
								  {
									  return -1;
								  }
								  else if (A > B)
								  {
									  return 1;
								  }
								  return 0;
							  });
			return this;
		}

		public function compare(a:Definition, b:Definition):int
		{
			var result:int;
			for each (var comparator:Function in _comparators)
			{
				result = comparator(a, b);
				if (result != 0)
				{
					return result;
				}
			}
			return 0;
		}
	}
}