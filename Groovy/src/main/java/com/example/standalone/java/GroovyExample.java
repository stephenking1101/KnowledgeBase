package com.example.standalone.java;

import javax.script.Invocable;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GroovyExample {

	private static Logger logger = LoggerFactory.getLogger(GroovyExample.class);
			
	private static ScriptEngine loadScript(String groovyScript) {		
		ScriptEngineManager factory = new ScriptEngineManager(GroovyExample.class.getClassLoader());
		ScriptEngine engine = factory.getEngineByName("groovy");
		if (engine == null) {
			logger.error("Could not find groovy script engine.");
		}
		
		try {
			engine.eval(groovyScript);
		} catch (ScriptException e) {
			logger.error("Execute script failed.", e);
		}
		return engine;
	}
	
	private static Object invokeGroovyScript(ScriptEngine scriptEngine, String method, Object[] params) {
        try {
            Invocable inv = (Invocable) scriptEngine;
            return inv.invokeFunction(method, params);
        } catch (NoSuchMethodException | ScriptException e) {
            logger.error("Could not execute method: {} in groovy script, so return empty response", method, e);
        }
        return null;
    }

	public static void main(String[] args){
		String script = "import groovy.transform.Field;" +
						"import org.slf4j.Logger;" + 
						"@Field Logger logger;" +
					    "String printInfo(name, gender, age, Logger logger){" +
					    "this.logger=logger;" + 
					    "logger.debug(\"name->$name gender->$gender age->$age\");" +
					    "println(\"System Out: name->'$name' gender->'$gender' age->'$age'\");" +
					    "return 'done';" + 
						"};";
		ScriptEngine scriptEngine = loadScript(script);
		
		Object[] params = new Object[] { "my name", "man", 12, logger };
		Object result = invokeGroovyScript(scriptEngine, "printInfo", params);
		System.out.println("System Out: " + result);
	}
}
