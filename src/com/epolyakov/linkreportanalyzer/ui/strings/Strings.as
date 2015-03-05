package com.epolyakov.linkreportanalyzer.ui.strings
{
	import com.epolyakov.linkreportanalyzer.version;

	use namespace version;

	/**
	 * @author epolyakov
	 */
	public class Strings
	{
		public static const openReportLabel:String = "Open";
		public static const openExampleLabel:String = "Example";
		public static const openHelpLabel:String = "About";

		public static const openReportTooltip:String = "Open link report";
		public static const openExampleTooltip:String = "Open example";
		public static const openHelpTooltip:String = "About";

		public static const showPackagesTooltip:String = "Show packages";
		public static const showDefinitionsTooltip:String = "Show compiled definitions";
		public static const showExternalsTooltip:String = "Show external definitions";

		public static const textFilterTooltip:String = "Filter by definition id";

		public static const aboutAppName:String = "ActionScript Link Report Analyzer";
		public static const aboutVersion:String = "version " + version;
		public static const aboutContent:String = "" +
				"The application is a tool for examining Action Script link reports. " +
				"It allows to get detailed info on each definition and package, " +
				"search and filter definitions, investigate definition dependencies.<br/><br/>" +
				"Create link report of your build and open it with the tool. " +
				"Or you can use an <a href='event:openExample'>example</a> which is a report of this application itself.<br/><br/>" +
				"For more information see <a target='_blank' href='http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf67110-7ff4.html#WS2db454920e96a9e51e63e3d11c0bf69084-7adc'>Adobe Help</a>.<br/>" +
				"Any issues can be reported to <a target='_blank' href='https://bitbucket.org/epolyakov/linkreportanalyzer/issues'>Bug Tracker</a>.";
	}
}