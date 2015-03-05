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
	/**
	 * @author epolyakov
	 */
	public class DependencyFactory
	{
		private var _linkReport:LinkReport;
		private var _rootDefinition:Definition;
		private var _isPrerequisite:Boolean;

		public function DependencyFactory(linkReport:LinkReport, rootDefinition:Definition, isPrerequisite:Boolean)
		{
			_linkReport = linkReport;
			_rootDefinition = rootDefinition;
			_isPrerequisite = isPrerequisite;
		}

		public function get linkReport():LinkReport
		{
			return _linkReport;
		}

		public function get rootDefinition():Definition
		{
			return _rootDefinition;
		}

		public function getDependencies(definition:Definition):Vector.<Definition>
		{
			if (_isPrerequisite)
			{
				return definition.prerequisites;
			}
			return definition.dependencies;
		}
	}
}