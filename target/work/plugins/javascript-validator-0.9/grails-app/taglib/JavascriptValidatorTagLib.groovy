import org.codehaus.groovy.grails.commons.*
import org.codehaus.groovy.grails.validation.*

class JavascriptValidatorTagLib {


    static namespace = 'jv'

    // Maps out how Grails contraints map to Apache commons validators
    static CONSTRAINT_TYPE_MAP = [blank: 'required',
            email: 'email',
            creditCard: 'creditCard',
            matches: 'mask',
            nullable: 'required',
            range: 'intRange']

    def generate = {attrs, body ->
        out << jv.generateValidation(attrs, body)
    }

    def generateValidation = {attrs, body ->

        def form = attrs["form"]
        def domainClassName = attrs["domain"]
        def commandClassName = attrs["command"]
        def controllerClassName = attrs["controller"]
        def focusField = attrs["focus"] ?: 'true';
        def displayType = attrs["display"] ?: 'alert';
        def errorsContainer = attrs["container"]
        def errorHandlerFunction = attrs["handler"] ?: "";
        def ignoreFields = attrs["ignore"] ?: []
        def displayOrder = attrs["order"] ?: []
        def disableSubmitButton = attrs["disableSubmitButton"] ?: null
        def useEmbeddedJquery = attrs.useEmbeddedJquery?Boolean.parseBoolean(attrs.useEmbeddedJquery).booleanValue():true
        useEmbeddedJquery = (disableSubmitButton != null && useEmbeddedJquery)?true:false;

        def targetName = validateAttributesAndGetTargetName(controllerClassName, commandClassName, domainClassName, form, displayType, errorsContainer, errorHandlerFunction)

        def targetClass = getTargetClass(domainClassName, commandClassName, controllerClassName)

        def fieldDataTypes = getFieldDataTypes(targetClass, ignoreFields)

        def constraints = getConstraints(targetClass)

        if (constraints || !fieldDataTypes.isEmpty()) {
            def allValidations;

            out << '<script type="text/javascript">\n'
            out << '//<![CDATA[\n'
            if (constraints) {
                def fieldValidations = getFieldValidations(constraints, ignoreFields)
                allValidations = writeFieldValidationFunctions(fieldValidations, fieldDataTypes, form, targetName, out)
                writeValidateFormFunction(allValidations)
                if(disableSubmitButton){
                    writeValidateFormAndDisableSubmitFunction(disableSubmitButton)
                }
            } else if (!fieldDataTypes.isEmpty()) {
                writeNumberMaskFunction(fieldDataTypes, ['decimal', 'number'], form, targetName, out)
                allValidations = ['mask']
                writeValidateFormFunction(allValidations)
                if(disableSubmitButton){
                    writeValidateFormAndDisableSubmitFunction(disableSubmitButton)
                }
            }
            writeErrorHandlerFunction(focusField, displayType, displayOrder, errorsContainer, errorHandlerFunction)
            //  out << "document.forms['${attrs['form']}'].onsubmit = function(e) {return validateForm(this)}\n"
            out << '//]]>\n'
            out << '</script>\n'
            writeJavascriptLibs(allValidations,useEmbeddedJquery, out)
        } else {
            out << "<!--NO CLIENT VALIDATION IS REQUIRED-->"
        }


    }


    private def getConstraints(targetClass) {

        if (targetClass instanceof GrailsDomainClass) {

            def constrainedProperties = targetClass.constrainedProperties
            if (constrainedProperties)
                return targetClass.constrainedProperties.collect {k, v -> return v }
        } else {
            def constrainedProperties = targetClass.constraints
            if (constrainedProperties)
                return constrainedProperties.collect {k, v -> return v }
        }
        return null
    }

    def getTargetClass(domainClassName, commandClassName, controller) {
        def app = grailsAttributes.getGrailsApplication()
        if (domainClassName) {
            def domainClass = app.getArtefactByLogicalPropertyName(DomainClassArtefactHandler.TYPE, domainClassName)
            if (domainClass) {
                return domainClass;
            } else {
                throwTagError("Tag [jv:generateValidation] cannot find the domain class [$domainClassName]")
            }
        } else if (commandClassName && controller) {
            //def controllerClass = app.getArtefact("Controller", controllerClassName.substring(0, 1).toUpperCase() + controllerClassName.substring(1) + "Controller")
            def controllerClass = grailsApplication.getArtefactByLogicalPropertyName(ControllerArtefactHandler.TYPE, controller)
            if (controllerClass) {
                def list = controllerClass.commandObjectClasses

                def commandClass = list.find {clazz ->
                    def name = grails.util.GrailsNameUtils.getPropertyName(clazz)
                    name == commandClassName
                }

                if (commandClass) {
                    def commandClassInst = commandClass.newInstance()
                    return commandClassInst;
                } else {
                    throwTagError("Tag [jv:generateValidation] cannot find the command class [$commandClassName]")
                }
            } else {
                throwTagError("Tag [jv:generateValidation] cannot find the controller class [$controllerClassName]")
            }

        }
        return null

    }

    private def validateAttributesAndGetTargetName(controllerClassName, commandClassName, domainClassName, form, displayType, errorsContainer, errorHandlerFunction) {
        if (!form)
            throwTagError("Tag [jv:generateValidation] Error: Tag missing required attribute [form]")

        if (form =~ /[^0-9A-Za-z]+/)
            throwTagError("Tag [jv:generateValidation] Error: Unfortunely the [form] attribute can only contain letters and digits")

        if (displayType == 'list' && !errorsContainer)
            throwTagError("Tag [jv:generateValidation] Error: You must supply [container] attribute when display = 'list'")

        if (displayType == 'custom' && !errorHandlerFunction)
            throwTagError("Tag [jv:generateValidation] Error: You must supply [handler] attribute when display = 'custom'")

        if (!domainClassName) {
            if (!commandClassName && !controllerClassName) {
                throwTagError("Tag [jv:generateValidation] Error: Tag missing attribute [domain] or attributes [command] and [controller]")
            } else {
                return commandClassName
            }
        } else {
            return domainClassName
        }


    }

    private def writeErrorHandlerFunction(focusField, displayType, displayOrder, errorsContainer, errorHandlerFunction) {
        out << 'function jcv_handleErrors(messages, focusField) {\n';
        if (focusField == 'true') {
            out << 'jcv_focusField(focusField);\n';
        }

        def displayOrderString = (displayOrder.size() > 0) ? "'" + displayOrder.join("','") + "'" : "";

        if (displayType == 'list' && errorsContainer) {
            out << "jcv_displayErrorsAsList('" + errorsContainer + "',messages,new Array($displayOrderString));\n";
        } else if (displayType == 'custom') {
            out << "$errorHandlerFunction(messages);\n"
        } else if (displayType == 'alert') {
            out << "jcv_displayErrorsAsAlert(messages,new Array($displayOrderString));\n";
        }

        out << '}\n'
    }

    private def writeValidateFormFunction(allValidations) {

        def weighting = ['required': 100, 'mask': 99, 'intRange': 98]
        def functionCalls = allValidations.sort {c1, c2 ->
            if (c1 == c2) return 0;
            if (c1 == null) return -1;
            if (c2 == null) return 1;

            def c1w = weighting[c1] ?: 1
            def c2w = weighting[c2] ?: 1

            if (c1w < c2w) return 1;

            return -1;
        }

        out << 'function validateForm(form) {\n'

        functionCalls.each {
            def validateType = it.substring(0, 1).toUpperCase() + it.substring(1)
            out << "if(!validate${validateType}(form)) return false;\n"
        }

        out << 'return true;\n';
        out << '}\n\n'

    }

    private def writeValidateFormAndDisableSubmitFunction(submitButtonName){
        out << 'function validateFormAndDisableSubmit(form) {\n'
        out << 'var isValid = validateForm(form);\n'
        out << 'if (isValid) {\n'
        out << '    $("#' + submitButtonName + '").attr("disabled", "disabled");\n'
        out << '    return true;\n'
        out << '} else {\n'
        out << '    return false;\n'
        out << '}\n'

        out << '}\n\n'
    }

    private def writeFieldValidationFunctions(fieldValidations, fieldDataTypes, form, model, out) {
        boolean handledNumberTypes = false;

        fieldValidations.each {k, v ->
            def validateType = k

            if (validateType) {

                def validateTypes = [validateType]

                if (validateType.contains(",")) {
                    validateTypes = validateType.split(",")
                }


                validateTypes.each {vt ->
                    out << "function ${form}_${vt}() {\n"

                    v.each {constraint ->

                        if (vt == 'mask') {
                            writeFieldDataTypesFunctions(fieldDataTypes, ['decimal', 'number'], form, model, out)
                            handledNumberTypes = true;
                        }

                        out << "this.${constraint.propertyName} = new Array("
                        out << "\"${constraint.propertyName}\"" // the field

                        def message = getI18nMessage(model, constraint.propertyName, constraint.name)

                        out << ',"' + message + '"'
                        switch (vt) {
                            case 'mask': out << ",function() { return new RegExp('${constraint.regex}'); }"; break;
                            case 'intRange': out << ",function() { if(arguments[0]=='min') return ${constraint.range.from}; else return ${constraint.range.to} }"; break;
                            case 'floatRange': out << ",function() { if(arguments[0]=='min') return ${constraint.range.from}; else return ${constraint.range.to} }"; break;
                            case 'maxLength': out << ",function() { return ${constraint.maxValue};  }"; break;
                            case 'minLength': out << ",function() { return ${constraint.minValue};  }"; break;
                        }
                        out << ');\n'

                    }

                    out << "};\n"
                }
            }
        }

        def allValidations = fieldValidations.keySet().collect {it}

        if (!handledNumberTypes && !fieldDataTypes.isEmpty()) {
            writeNumberMaskFunction(fieldDataTypes, ['decimal', 'number'], form, model, out)
            allValidations << "mask";
        }

        return allValidations

    }

    def getI18nMessage(model, field, constraintName) {
        def code = model + "." + field + "." + constraintName
        def codeAndDefaultCode = generateCodeAndDefaultCode(code, constraintName)
        code = codeAndDefaultCode[0]
        def defaultCode = codeAndDefaultCode[1]
        def message = g.message([code: code])
        if (message == code)
            message = g.message([code: defaultCode, args: [field, model]]);

        return message;
    }

    private void writeNumberMaskFunction(fieldDataTypes, validationTypes, form, model, out) {
        if (!fieldDataTypes.isEmpty()) {
            out << "function ${form}_mask() {\n"
            writeFieldDataTypesFunctions(fieldDataTypes, ['decimal', 'number'], form, model, out)
            out << '};\n'
        }
    }

    private def getFieldDataTypes(targetClass, ignoreFields) {
        def fieldDataTypes = [:]
        targetClass.metaClass.properties.each {metaProp ->

            if (!ignoreFields.contains(metaProp.name)) {

                if (!(targetClass instanceof GrailsDomainClass) || (metaProp.name != 'id' && metaProp.name != 'version')) {
                    def type

                    if (Float == metaProp.type || Double == metaProp.type || BigDecimal == metaProp.type) {
                        type = "decimal"
                    } else if (metaProp.type.getSuperclass() == Number.class) {
                        type = "number"
                    }
                    if (type) {

                        if (fieldDataTypes[type]) {
                            fieldDataTypes[type] << [metaProp.name, metaProp.type.name]
                        }
                        else {
                            fieldDataTypes[type] = [[metaProp.name, metaProp.type.name]]
                        }
                    }
                }
            }

        }
        return fieldDataTypes;
    }

    private void writeFieldDataTypesFunctions(fieldDataTypes, validationTypes, form, model, out) {

        fieldDataTypes.each {k, fields ->

            if (validationTypes.contains(k)) {
                def validationType = k

                fields.each {info ->

                    def field = info[0]
                    def type = info[1]
                    out << "this.${field} = new Array("
                    out << "\"${field}\"" // the field


                    def message = getI18nMessage(model, field, type)

                    out << ',"' + message + '"'
                    switch (validationType) {
                        case 'decimal': out << ",function() { return new RegExp('^[-+]?[0-9]*\\.?[0-9]+\$'); }"; break;
                        case 'number': out << ",function() { return new RegExp('^[0-9]+\$'); }"; break;
                    }
                    out << ');\n'
                }
            }
        }
    }

    private def getFieldValidations(constrainedProperties, ignoreFields) {

        def appliedConstraints = []

        // remove nullable constraints on strings as they are pointless for us. If you do not enter a value in the form
        // then it gets set to empty string NOT null so not worth null check
        constrainedProperties.each {constraintProperty ->
            if (String == constraintProperty.propertyType) {
                def blankConstraint = null;
                def nullableConstraint = null;
                constraintProperty.appliedConstraints.each {constraint ->
                    if (constraint.name == ConstrainedProperty.NULLABLE_CONSTRAINT) {
                        nullableConstraint = constraint
                    } else if (constraint.name == ConstrainedProperty.BLANK_CONSTRAINT) {
                        blankConstraint = constraint
                    } else {
                        appliedConstraints << constraint
                    }
                }
                // blank constraint overides nullable for strings
                if (blankConstraint) {
                    if (!blankConstraint.blank) {
                        appliedConstraints << blankConstraint
                    }

                } else if (nullableConstraint) {
                    if (!nullableConstraint.nullable) {
                        appliedConstraints << nullableConstraint
                    }
                }
            } else {
                constraintProperty.appliedConstraints.each {constraint ->

                    if (constraint.name == ConstrainedProperty.NULLABLE_CONSTRAINT) {
                        if (!constraint.nullable) {
                            appliedConstraints << constraint
                        }
                    } else if (constraint.name == ConstrainedProperty.BLANK_CONSTRAINT) {
                        if (!constraint.blank) {
                            appliedConstraints << constraint
                        }
                    } else {
                        appliedConstraints << constraint
                    }

                }
            }
        }

        appliedConstraints = appliedConstraints.flatten()

        def fieldValidations = [:]
        appliedConstraints.each {constraint ->

            if (!ignoreFields.contains(constraint.propertyName)) {

                def validateType = CONSTRAINT_TYPE_MAP[constraint.name]
                if (validateType) {
                    if (fieldValidations[validateType]) {
                        fieldValidations[validateType] << constraint
                    }
                    else {
                        fieldValidations[validateType] = [constraint]
                    }
                }
            }
        }
        return fieldValidations
    }


    private void writeJavascriptLibs(allValidations,useEmbeddedJquery, out) {

        def jsUtilSrc = createJsSrc("js/validator/validateUtilities.js")
        out << "<script type=\"text/javascript\" src=\"$jsUtilSrc\"></script>\n"

        allValidations.each {validationType ->

            def scriptName = "validate" + validationType.substring(0, 1).toUpperCase() + validationType.substring(1) + ".js"
            def jsSrc = createJsSrc("js/validator/$scriptName")
            out << "<script type=\"text/javascript\" src=\"$jsSrc\"></script>\n"

        }

        if(useEmbeddedJquery){
            def jsJquerySrc = createJsSrc("js/jquery/jquery-1.3.1.min.js")
            out << "<script type=\"text/javascript\" src=\"$jsJquerySrc\"></script>\n"
        }

    }

    def createJsSrc(fileName) {
        return g.createLinkTo(dir: pluginContextPath, file: fileName)
    }

    private def generateCodeAndDefaultCode(String code, String constraintName) {
        def defaultCode
        switch (constraintName) {

            case 'nullable':
                defaultCode = org.codehaus.groovy.grails.validation.ConstrainedProperty.DEFAULT_NULL_MESSAGE_CODE
                break;
            case 'blank':
                defaultCode = org.codehaus.groovy.grails.validation.ConstrainedProperty.DEFAULT_BLANK_MESSAGE_CODE
                break;
            case 'creditCard':
                code += ".invalid";
                defaultCode = org.codehaus.groovy.grails.validation.ConstrainedProperty.DEFAULT_INVALID_CREDIT_CARD_MESSAGE_CODE
                break;
            case 'email':
                code += ".invalid";
                defaultCode = org.codehaus.groovy.grails.validation.ConstrainedProperty.DEFAULT_INVALID_EMAIL_MESSAGE_CODE
                break;
            case 'matches':
                code += ".invalid";
                defaultCode = org.codehaus.groovy.grails.validation.ConstrainedProperty.DEFAULT_DOESNT_MATCH_MESSAGE_CODE
                break;
            case 'range':
                code += ".outside";
                defaultCode = org.codehaus.groovy.grails.validation.ConstrainedProperty.DEFAULT_INVALID_RANGE_MESSAGE_CODE
                break;
            case 'java.lang.Double':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.lang.Double"
                break;
            case 'java.lang.Float':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.lang.Float"
                break;
            case 'java.lang.Integer':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.lang.Integer"
                break;
            case 'java.lang.Long':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.lang.Long"
                break;
            case 'java.lang.Short':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.lang.Short"
                break;
            case 'java.lang.BigDecimal':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.lang.BigDecimal"
                break;
            case 'java.lang.BigInteger':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.lang.BigInteger"
                break;
            case 'java.util.Date':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.util.Date"
                break;
            case 'java.net.URL':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.net.URL"
                break;
            case 'java.net.URI':
                code = "typeMismatch." + code;
                defaultCode = "typeMismatch.java.net.URI"
                break;
        }

        return [code, defaultCode]

    }


}
