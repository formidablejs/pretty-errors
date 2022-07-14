function requireDefault$__(obj){
	return obj && obj.__esModule ? obj : { default: obj };
};
Object.defineProperty(exports, "__esModule", {value: true});

/*body*/
var $1 = require('@formidablejs/framework'/*$path$*/);
var $2 = require('@formidablejs/framework'/*$path$*/);
var $3 = require('@formidablejs/framework'/*$path$*/);
var $4 = require('@formidablejs/framework'/*$path$*/);
var $5 = require('@formidablejs/framework'/*$path$*/);
var $6 = requireDefault$__(require('fs'/*$path$*/));
var $7 = requireDefault$__(require('path'/*$path$*/));
var $8 = requireDefault$__(require('youch'/*$path$*/));

class PrettyErrorsServiceResolver extends $4.ServiceResolver {
	
	
	boot(){
		var self = this;
		
		self.app.addHook('onMaintenance',function(/**@type {Error}*/response,/**@type {FormRequest}*/request,/**@type {FastifyReply}*/reply) {
			
			self.modifyHeaders(response,request,reply);
			
			if ((response instanceof Error) && !(request.expectsJson())) {
				
				return self.handleProductionErrors(response,request,reply);
			};
		});
		
		return self.app.onResponse(function(response,/**@type {FormRequest}*/request,/**@type {FastifyReply}*/reply) {
			
			self.modifyHeaders(response,request,reply);
			
			if ((response instanceof Error) && !(request.expectsJson())) {
				
				return self.errorHandler(response,request,reply);
			};
		});
	}
	
	modifyHeaders(response,request,reply){
		
		if (request.hasHeader('x-formidable-request') && (response instanceof Error) && !((response instanceof $5.ValidationException))) {
			
			request.req.headers.accept = 'text/html';
			return reply.header('accept','text/html');
		};
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
		
		const statusCode = $3.helpers.isEmpty(response.status) ? 500 : response.status;
		const message = (statusCode == 500) ? 'Internal Server Error' : (((statusCode == 404) ? 'Not Found' : response.message));
		
		const errorPage = $7.default.join(__dirname,'..','assets','error.html');
		
		let html = message;
		
		if ($6.default.existsSync(errorPage)) {
			
			html = $6.default.readFileSync(errorPage,'utf8');
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
		
		if ($3.helpers.isEmpty(response.status)) {
			
			response.status = 500;
		};
		
		const youch = new $8.default(response,request.request.raw);
		
		return youch.toHTML().then(function(html) {
			
			reply.header('Content-Type','text/html');
			reply.send(html);
			return reply.sent = true;
		});
	}
};
exports.default = PrettyErrorsServiceResolver;
