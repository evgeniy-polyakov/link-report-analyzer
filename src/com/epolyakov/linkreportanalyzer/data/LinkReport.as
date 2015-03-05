package com.epolyakov.linkreportanalyzer.data
{
	/**
	 * @author epolyakov
	 */
	public class LinkReport
	{
		private var _source:XML;
		private var _lookup:Object;
		private var _vector:Vector.<Definition>;
		private var _maxLevel:int = 0;

		public function LinkReport(source:XML)
		{
			_source = source;

			createDefinitions();
			createPackages();
			iterateDefinitions();
		}

		public function getDefinition(id:String):Definition
		{
			return _lookup[id];
		}

		public function getDefinitions():Vector.<Definition>
		{
			return _vector;
		}

		public function get maxLevel():int
		{
			return _maxLevel;
		}

		private function createDefinitions():void
		{
			_lookup = {};
			var tempDependencies:Object = {};
			var tempPrerequisites:Object = {};

			// Fill definitions and temp dependencies
			var ns:Namespace = _source.namespace("");

			// http://code.google.com/p/redtamarin/wiki/SWC

			var scriptName:Object = ns ? new QName(ns, "script") : "script";
			var defName:Object = ns ? new QName(ns, "def") : "def";
			var depName:Object = ns ? new QName(ns, "dep") : "dep";
			var preName:Object = ns ? new QName(ns, "pre") : "pre";

			for each (var scriptXML:XML in _source.descendants(scriptName))
			{
				var defXML:XML = scriptXML[defName][0];
				if (defXML)
				{
					var definition:Definition = new Definition();
					definition.id = defXML.@id;
					definition.script = scriptXML.@name;
					definition.modified = scriptXML.@mod;
					definition.size = scriptXML.@size;
					definition.optimizedSize = scriptXML.@optimizedsize;
					definition.name = definition.id.slice(definition.id.lastIndexOf(":") + 1);

					var v:Vector.<String>;

					v = tempDependencies[definition.id] = new <String>[];
					for each (var depXML:XML in scriptXML[depName])
					{
						v.push(depXML.@id);
					}

					v = tempPrerequisites[definition.id] = new <String>[];
					for each (var preXML:XML in scriptXML[preName])
					{
						v.push(preXML.@id);
					}

					_lookup[definition.id] = definition;
				}
			}

			// Create external definitions
			for each (var extXML:XML in _source["external-defs"]["ext"])
			{
				definition = _lookup[extXML.@id];
				if (definition == null)
				{
					definition = new Definition();
					definition.id = extXML.@id;
					definition.name = definition.id.slice(definition.id.lastIndexOf(":") + 1);
					_lookup[definition.id] = definition;
				}
				definition.isExternal = true;
			}

			// Fill dependencies and prerequisites
			for each (definition in _lookup)
			{
				var id:String;
				for each (id in tempDependencies[definition.id])
				{
					var dependency:Definition = _lookup[id];
					if (dependency)
					{
						definition.dependencies.push(dependency);
					}
				}
				for each (id in tempPrerequisites[definition.id])
				{
					var prerequisite:Definition = _lookup[id];
					if (prerequisite)
					{
						definition.prerequisites.push(prerequisite);
					}
				}
			}
		}

		private function createPackages():void
		{
			var tempPackages:Object = {};
			var topmostPackage:Definition = new Definition();
			topmostPackage.id = "";
			topmostPackage.name = "";
			topmostPackage.isPackage = true;
			topmostPackage.isExternal = true;
			tempPackages[topmostPackage.id] = topmostPackage;

			for each (var classDefinition:Definition in _lookup)
			{
				var className:String = classDefinition.id;
				var childDefinition:Definition = classDefinition;
				var packageDefinition:Definition;
				var packageName:String;

				// Add to all named packages
				var index:int = className.lastIndexOf(":");
				while (index >= 0)
				{
					packageName = className.slice(0, index);
					packageDefinition = tempPackages[packageName];
					if (packageDefinition == null)
					{
						packageDefinition = new Definition();
						packageDefinition.id = packageName;
						packageDefinition.name = packageName.slice(packageName.lastIndexOf(".") + 1);
						packageDefinition.isPackage = true;
						packageDefinition.isExternal = true;
						tempPackages[packageName] = packageDefinition;
					}
					addToPackage(packageDefinition, childDefinition, classDefinition);

					childDefinition = packageDefinition;
					index = className.lastIndexOf(".", index - 1);
				}
				addToPackage(topmostPackage, childDefinition, classDefinition);
			}

			for each (packageDefinition in tempPackages)
			{
				_lookup[packageDefinition.id] = packageDefinition;
			}
		}

		private function addToPackage(packageDefinition:Definition, childDefinition:Definition,
									  classDefinition:Definition):void
		{
			if (packageDefinition.children.indexOf(childDefinition) < 0)
			{
				childDefinition.parent = packageDefinition;
				packageDefinition.children.push(childDefinition);
				packageDefinition.isExternal &&= childDefinition.isExternal;
			}
			addDefinitionVector(packageDefinition.dependencies, classDefinition.dependencies);
			addDefinitionVector(packageDefinition.prerequisites, classDefinition.prerequisites);

			packageDefinition.size += classDefinition.size;
			packageDefinition.optimizedSize += classDefinition.optimizedSize;
			packageDefinition.modified = Math.max(packageDefinition.modified, classDefinition.modified);
		}

		private function addDefinitionVector(existing:Vector.<Definition>, additional:Vector.<Definition>):void
		{
			for each (var d:Definition in additional)
			{
				if (existing.indexOf(d) < 0)
				{
					existing.push(d);
				}
			}
		}

		private function iterateDefinitions():void
		{
			_vector = new <Definition>[];
			var allComparator:Function = new DefinitionSort().byPackage.byExternal.byId.compare;
			var childrenComparator:Function = new DefinitionSort().byPackage.byName.compare;
			var dependencyComparator:Function = new DefinitionSort().byExternal.byId.compare;
			for each (var definition:Definition in _lookup)
			{
				definition.children.sort(childrenComparator);
				definition.dependencies.sort(dependencyComparator);
				definition.prerequisites.sort(dependencyComparator);
				_vector.push(definition);
				setDefinitionLevel(definition);
			}
			_vector.sort(allComparator);
		}


		private function setDefinitionLevel(definition:Definition):void
		{
			definition.level = 0;
			var parent:Definition = definition;
			while (parent = parent.parent)
			{
				definition.level++;
			}
			if (definition.level > _maxLevel)
			{
				_maxLevel = definition.level;
			}
		}
	}
}