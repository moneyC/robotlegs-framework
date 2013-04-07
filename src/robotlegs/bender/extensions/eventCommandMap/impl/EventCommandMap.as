//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.Injector;

	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandTriggerMap;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * @private
	 */
	public class EventCommandMap implements IEventCommandMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		private var _triggerMap:CommandTriggerMap;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function EventCommandMap(context:IContext, dispatcher:IEventDispatcher)
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			_dispatcher = dispatcher;
			_triggerMap = new CommandTriggerMap(getKey, createTrigger);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function map(type:String, eventClass:Class = null):ICommandMapper
		{
			return getTrigger(type, eventClass).createMapper();
		}

		/**
		 * @inheritDoc
		 */
		public function unmap(type:String, eventClass:Class = null):ICommandUnmapper
		{
			return getTrigger(type, eventClass).createMapper();
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function getKey(type:String, eventClass:Class):String
		{
			return type + eventClass;
		}

		private function createTrigger(type:String, eventClass:Class):EventCommandTrigger
		{
			return new EventCommandTrigger(_injector, _dispatcher, type, eventClass, _logger);
		}

		private function getTrigger(type:String, eventClass:Class):EventCommandTrigger
		{
			return _triggerMap.getTrigger(type, eventClass) as EventCommandTrigger;
		}
	}
}
