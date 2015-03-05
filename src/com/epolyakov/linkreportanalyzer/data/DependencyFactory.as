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