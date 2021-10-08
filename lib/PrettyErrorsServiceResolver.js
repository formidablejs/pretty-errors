function requireDefault$__(obj){
	return obj && obj.__esModule ? obj : { default: obj };
};
Object.defineProperty(exports, "__esModule", {value: true});

/*body*/
var _$frameworkφ = require('@formidablejs/framework'/*$path$*/);

var _$youchφ = requireDefault$__(require('youch'/*$path$*/));

class PrettyErrorsServiceResolver extends _$frameworkφ.ServiceResolver {
	
	
	boot(){
		var self = this;
		
		self.app.onResponse(function(response,/**@type {FormRequest}*/request,/**@type {FastifyReply}*/reply) {
			
			if ((response instanceof Error) && self.app.config.get('app.debug',false) && !(request.expectsJson())) {
				
				if (_$frameworkφ.helpers.isEmpty(response.status)) {
					
					response.status = 500;
				};
				
				const youch = new _$youchφ.default(response,request.request.raw);
				
				return youch.toHTML().then(function(html) {
					
					reply.header('Content-Type','text/html');
					reply.send(html);
					return reply.sent = true;
				});
			};
		});
		
		return self;
	}
};
exports.default = PrettyErrorsServiceResolver;
