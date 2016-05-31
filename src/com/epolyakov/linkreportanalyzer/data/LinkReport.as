/**
 Copyright 2014 Evgeniy Polyakov

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
package com.epolyakov.linkreportanalyzer.data
{
	import flash.utils.Dictionary;

	/**
	 * @author epolyakov
	 */
	public class LinkReport
	{
		private var _source:XML;
		private var _lookup:Dictionary;
		private var _vector:Vector.<Definition>;
		private var _maxLevel:int = 0;

		public function LinkReport(source:XML)
		{
			_source = source;

			createDefinitions();
			createPackages();
			deleteSingleChildPackages();
			sortDefinitions();
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
			_lookup = new Dictionary();
			var tempDependencies:Object = {};
			var tempPrerequisites:Object = {};

			// Fill definitions and temp dependencies
			var defId:String;
			var ns:Namespace = _source.namespace("");
			var scriptName:Object = ns ? new QName(ns, "script") : "script";
			var defName:Object = ns ? new QName(ns, "def") : "def";
			var depName:Object = ns ? new QName(ns, "dep") : "dep";
			var preName:Object = ns ? new QName(ns, "pre") : "pre";
			var extName:Object = ns ? new QName(ns, "ext") : "ext";
			var extDefName:Object = ns ? new QName(ns, "external-defs") : "external-defs";

			for each (var scriptXML:XML in _source.descendants(scriptName))
			{
				var defXML:XML = scriptXML[defName][0];
				if (defXML)
				{
					var definition:Definition = newCompiledDefinition(defXML, scriptXML);
					var v:Vector.<String>;

					v = tempDependencies[definition.id] = new <String>[];
					for each (var depXML:XML in scriptXML[depName])
					{
						var depId:String = depXML.@id;
						if (v.indexOf(depId) < 0)
						{
							v.push(depId);
						}
					}

					v = tempPrerequisites[definition.id] = new <String>[];
					for each (var preXML:XML in scriptXML[preName])
					{
						var preId:String = preXML.@id;
						if (v.indexOf(preId) < 0)
						{
							v.push(preId);
						}
					}

					_lookup[definition.id] = definition;
				}
			}

			// Create external definitions
			for each (var extXML:XML in _source[extDefName][extName])
			{
				definition = _lookup[String(extXML.@id)];
				if (definition == null)
				{
					definition = newExternalDefinition(extXML.@id);
					_lookup[definition.id] = definition;
				}
				definition.isExternal = true;
			}

			// Create externals for missing definitions
			var missingDefinitions:Vector.<Definition> = new <Definition>[];
			for each (definition in _lookup)
			{
				for each (defId in tempDependencies[definition.id])
				{
					if (!_lookup[defId])
					{
						missingDefinitions.push(newExternalDefinition(defId));
					}
				}
				for each (defId in tempPrerequisites[definition.id])
				{
					if (!_lookup[defId])
					{
						missingDefinitions.push(newExternalDefinition(defId));
					}
				}
			}
			for each (definition in missingDefinitions)
			{
				_lookup[definition.id] = definition;
			}

			// Fill dependencies and prerequisites
			for each (definition in _lookup)
			{
				for each (defId in tempDependencies[definition.id])
				{
					var dependency:Definition = _lookup[defId];
					if (dependency)
					{
						definition.dependencies.push(dependency);
					}
				}
				for each (defId in tempPrerequisites[definition.id])
				{
					var prerequisite:Definition = _lookup[defId];
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
			var topmostPackage:Definition = newPackageDefinition("");
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
						packageDefinition = newPackageDefinition(packageName);
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
			addPackageDependencies(packageDefinition.id, packageDefinition.dependencies, classDefinition.dependencies);
			addPackageDependencies(packageDefinition.id, packageDefinition.prerequisites, classDefinition.prerequisites);

			packageDefinition.size += classDefinition.size;
			packageDefinition.optimizedSize += classDefinition.optimizedSize;
			packageDefinition.modified = Math.max(packageDefinition.modified, classDefinition.modified);
		}

		private function addPackageDependencies(packageId:String, existing:Vector.<Definition>,
												additional:Vector.<Definition>):void
		{
			for each (var d:Definition in additional)
			{
				// Ad only new definitions from other packages
				if (existing.indexOf(d) < 0 && d.id.indexOf(packageId) < 0)
				{
					existing.push(d);
				}
			}
		}

		private function deleteSingleChildPackages(packageDefinition:Definition = null):void
		{
			var childDefinition:Definition;
			var parentDefinition:Definition;
			if (packageDefinition == null)
			{
				packageDefinition = _lookup[""];
			}
			if (packageDefinition.parent != null &&
					packageDefinition.children.length == 1 &&
					packageDefinition.children[0].isPackage)
			{
				childDefinition = packageDefinition.children[0];
				parentDefinition = packageDefinition.parent;
				var index:int = parentDefinition.children.indexOf(packageDefinition);

				childDefinition.parent = packageDefinition.parent;
				childDefinition.level--;
				if (index >= 0)
				{
					parentDefinition.children[index] = childDefinition;
				}
				else
				{
					parentDefinition.children.push(childDefinition);
				}

				packageDefinition.children = null;
				packageDefinition.parent = null;
				delete _lookup[packageDefinition.id];

				deleteSingleChildPackages(childDefinition);
			}
			else
			{
				for each (childDefinition in packageDefinition.children.slice())
				{
					deleteSingleChildPackages(childDefinition);
				}
			}
		}

		private function sortDefinitions():void
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

		private function newCompiledDefinition(defXML:XML, scriptXML:XML):Definition
		{
			var d:Definition = new Definition();
			d.id = defXML.@id;
			d.script = scriptXML.@name;
			d.modified = scriptXML.@mod;
			d.size = scriptXML.@size;
			d.optimizedSize = scriptXML.@optimizedsize;
			d.name = d.id.slice(d.id.lastIndexOf(":") + 1);
			return d;
		}

		private function newExternalDefinition(id:String):Definition
		{
			var d:Definition = new Definition();
			d.id = id;
			d.name = d.id.slice(d.id.lastIndexOf(":") + 1);
			d.isExternal = true;
			return d;
		}

		private function newPackageDefinition(packageName:String):Definition
		{
			var d:Definition = new Definition();
			d.id = packageName;
			d.name = packageName.length > 0 ? packageName.slice(packageName.lastIndexOf(".") + 1) : packageName;
			d.isPackage = true;
			return d;
		}
	}
}