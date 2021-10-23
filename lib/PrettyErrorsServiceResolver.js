function requireDefault$__(obj){
	return obj && obj.__esModule ? obj : { default: obj };
};
Object.defineProperty(exports, "__esModule", {value: true});

/*body*/
var _$frameworkφ = require('@formidablejs/framework'/*$path$*/);
var _$frameworkφ2 = require('@formidablejs/framework'/*$path$*/);
var _$frameworkφ3 = require('@formidablejs/framework'/*$path$*/);
var _$frameworkφ4 = require('@formidablejs/framework'/*$path$*/);
var _$fsφ = requireDefault$__(require('fs'/*$path$*/));
var _$pathφ = requireDefault$__(require('path'/*$path$*/));
var _$youchφ = requireDefault$__(require('youch'/*$path$*/));

class PrettyErrorsServiceResolver extends _$frameworkφ4.ServiceResolver {
	
	
	boot(){
		var self = this;
		
		self.app.addHook('onMaintenance',function(/**@type {Error}*/response,/**@type {FormRequest}*/request,/**@type {FastifyReply}*/reply) {
			
			if ((response instanceof Error) && !(request.expectsJson())) {
				
				return self.handleProductionErrors(response,request,reply);
			};
		});
		
		return self.app.onResponse(function(response,/**@type {FormRequest}*/request,/**@type {FastifyReply}*/reply) {
			
			if ((response instanceof Error) && !(request.expectsJson())) {
				
				return self.errorHandler(response,request,reply);
			};
		});
	}
	
	/**
	@param {Error} response
	@param {FormRequest} request
	@param {FastifyReply} reply
	*/
	errorHandler(response,request,reply){
		
		if (this.app.config.get('app.debug',false)) {
			
			return this.handleDevelopmentErrors(response,request,reply);
		} else {
			
			return this.handleProductionErrors(response,request,reply);
		};
	}
	
	/**
	@param {Error} response
	@param {FormRequest} request
	@param {FastifyReply} reply
	*/
	handleProductionErrors(response,request,reply){
		
		const statusCode = _$frameworkφ3.helpers.isEmpty(response.status) ? 500 : response.status;
		const message = (statusCode == 500) ? 'Internal Server Error' : (((statusCode == 404) ? 'Not Found' : response.message));
		
		const errorPage = _$pathφ.default.join(__dirname,'..','assets','error.html');
		
		let html = message;
		
		if (_$fsφ.default.existsSync(errorPage)) {
			
			html = _$fsφ.default.readFileSync(errorPage,'utf8');
			html = html.replace(/{{statusCode}}/g,statusCode);
			html = html.replace(/{{message}}/g,message);
		};
		
		return reply.header('Content-Type','text/html').code(statusCode).send(html).sent = true;
	}
	
	/**
	@param {Error} response
	@param {FormRequest} request
	@param {FastifyReply} reply
	*/
	handleDevelopmentErrors(response,request,reply){
		
		if (_$frameworkφ3.helpers.isEmpty(response.status)) {
			
			response.status = 500;
		};
		
		const youch = new _$youchφ.default(response,request.request.raw);
		
		return youch.toHTML().then(function(html) {
			
			reply.header('Content-Type','text/html');
			reply.send(html);
			return reply.sent = true;
		});
	}
};
exports.default = PrettyErrorsServiceResolver;
