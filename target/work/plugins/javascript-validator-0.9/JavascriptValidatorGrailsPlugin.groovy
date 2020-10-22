class JavascriptValidatorGrailsPlugin {
    // the plugin version
    def version = "0.9"
    // the version or versions of Grails the plugin is designed for
    def grailsVersion = "1.1 > *"
    // the other plugins this plugin depends on
    def dependsOn = [:]
    // resources that are excluded from plugin packaging
    def pluginExcludes = [
            "grails-app/views/error.gsp",
            "grails-app/controllers/**/*",
            "grails-app/controllers/*",
            "grails-app/domain/**/*",
            "grails-app/domain/*",
            "grails-app/i18n/*.properties",
            "grails-app/views/**/*.gsp",
            "web-app/css/*.css",
            "web-app/js/prototype/*.js",
            "web-app/js/application.js",
    ]

    // TODO Fill in these fields
    def author = "Peter Delahunty"
    def authorEmail = "peter.delahunty@gmail.com"
    def title = "Client Side Javascript Validator"
    def description = '''\\
This plugin provides client side javascript validation for domain and command objects based on the constraints closure.
'''

    // URL to the plugin's documentation
    def documentation = "http://grails.org/JavascriptValidator+Plugin"

    def doWithSpring = {
        // TODO Implement runtime spring config (optional)
    }

    def doWithApplicationContext = { applicationContext ->
        // TODO Implement post initialization spring config (optional)
    }

    def doWithWebDescriptor = { xml ->
        // TODO Implement additions to web.xml (optional)
    }

    def doWithDynamicMethods = { ctx ->
        // TODO Implement registering dynamic methods to classes (optional)
    }

    def onChange = { event ->
        // TODO Implement code that is executed when any artefact that this plugin is
        // watching is modified and reloaded. The event contains: event.source,
        // event.application, event.manager, event.ctx, and event.plugin.
    }

    def onConfigChange = { event ->
        // TODO Implement code that is executed when the project configuration changes.
        // The event is the same as for 'onChange'.
    }
}
